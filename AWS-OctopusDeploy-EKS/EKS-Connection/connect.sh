# The below command asks for two inputs to set your current EKS cluster as the default kube config context.
# 1. Region of the EKS cluster
# 2. Name of the EKS cluster

aws eks --region us-east-1 update-kubeconfig --name odekscluster