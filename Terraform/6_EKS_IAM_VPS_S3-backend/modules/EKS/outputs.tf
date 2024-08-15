output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.vrp_cluster.id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.vrp_cluster.name
}
