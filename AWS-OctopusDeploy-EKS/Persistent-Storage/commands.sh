# The Amazon EFS CSI driver allows multiple pods to write to a volume at the same time with the ReadWriteMany mode.
# To deploy the AWS EFS CSI driver:
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=master"

# To get the VPC ID for your Amazon EKS cluster, run the following command and you should see an output
# of a VPC ID to the terminal
aws eks describe-cluster --name cluster_name --query "cluster.resourcesVpcConfig.vpcId" --output text

# A security group must be created for the EFS storage for firewall rules between the AWS services
# Ensure to save the group ID from the output from the command below for later use
aws ec2 create-security-group --description efs-test-sg --group-name efs-sg --vpc-id VPC_ID_from_command_above

# Get the CIDR range for the VPC to use in the command coming up next
aws ec2 describe-vpcs --vpc-ids VPC_ID_from_command_above --query "Vpcs[].CidrBlock" --output text

# To add an NFS inbound rule to enable resources in your VPC to communicate with your EFS, run the following command:
aws ec2 authorize-security-group-ingress --group-id security_group_id_that_you_created  --protocol tcp --port 2049 --cidr VPC_CIDR_range_from_command_above

# To create an Amazon EFS file system for your Amazon EKS cluster, run the following command:
# Ensure to save the "FileSystemId" for the next command
aws efs create-file-system --creation-token octopusdeploy-efs

# Create access points (mounting targets) in EFS
aws efs create-access-point --file-system-id file_system_id_from_command_above --root-directory Path=artifacts
aws efs create-access-point --file-system-id file_system_id_from_command_above --root-directory Path=taskLogs
aws efs create-access-point --file-system-id file_system_id_from_command_above --root-directory Path=repository

# To create a mount target for the EFS, run the following command in all the Availability Zones where your worker nodes are running:
# For example, if you have two subnet IDs for your EKS cluster, you'll want to run the below command for each subnet ID
aws efs create-mount-target --file-system-id file_system_id_from_command_above --subnet-id Subnet_ID --security-group security_group_id_that_you_created