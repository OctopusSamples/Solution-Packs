# Storage

Octopus Deploy stores most of it's data inside of the database. However, there are three directories that are stored on the local server that Octopus Deploy is deployed on.

- artifacts/
- taskLogs/
- repository/

Because Octopus Deploy is living in a Kubernetes pod running in EKS, you want to ensure that the three directores that hold the data are persisted.

## EFS
The configuration uses EFS, which is scalable file storage optimized for EC2. Since EFS allows you to mount file systems across multiple regions and instances, it's the perfect fit for node groups in EKS as they're EC2 instances on the backend.

## Creating Persistent Storage On An EKS Cluster
1. Run through the commands in the `commands.sh` file.
2. Deploy the EFS CSI (Container Storage Interface) provisioner
```
kubectl apply -k "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/dev/?ref=master"
```
3. Confirm the connection to the EFS CSI was successful
```
kubectl get csidrivers.storage.k8s.io
```
4. Retrieve the EFS filesystem ID for the Kubernetes storage class
```
aws efs describe-file-systems --query "FileSystems[*].FileSystemId"
```