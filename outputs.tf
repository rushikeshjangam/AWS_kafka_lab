output "eks_cluster_name" {
  value = aws_eks_cluster.this.name
}

output "kubeconfig_command" {
  value = "aws eks --region ${var.region} update-kubeconfig --name ${aws_eks_cluster.this.name}"
}
