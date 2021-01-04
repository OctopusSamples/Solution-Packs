provider "aws" {
  version = "~> 3.0"
  region  = var.region
}

resource "aws_iam_role" "odeks-iam" {
  name = "odeks-iam"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "ec2.amazonaws.com"
        ]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "od-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.odeks-iam.name
}

resource "aws_iam_role_policy_attachment" "od-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.odeks-iam.name
}

resource "aws_iam_role_policy_attachment" "od-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.odeks-iam.name
}

resource "aws_iam_role_policy_attachment" "od-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.odeks-iam.name
}

resource "aws_eks_cluster" "od-eks" {
  name     = "odekscluster"
  role_arn = aws_iam_role.odeks-iam.arn

  vpc_config {
    subnet_ids = [var.subnetID[0], var.subnetID[1]]
  }

  depends_on = [
    aws_iam_role_policy_attachment.od-AmazonEKSClusterPolicy,
  ]
}

resource "aws_eks_node_group" "od-workernodes" {
  cluster_name    = aws_eks_cluster.od-eks.name
  node_group_name = "odworkernodes"
  node_role_arn   = aws_iam_role.odeks-iam.arn
  subnet_ids      = [var.subnetID[0], var.subnetID[1]]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.od-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.od-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.od-AmazonEC2ContainerRegistryReadOnly,
  ]
}
