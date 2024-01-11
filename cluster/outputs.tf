output "connection_string" {
  value = "aws eks update-kubeconfig --region us-east-1 --name ${module.eks.cluster_name} --alias ${module.eks.cluster_name}"
}