output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.eks-tf_cluster.id
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.eks-tf_cluster.name
}
