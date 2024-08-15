output "cluster_role_arn_output" {
    value = aws_iam_role.vrp_cluster_role.arn
}

output "node_role_arn_output" {
  value = aws_iam_role.vrp_node_group_role.arn
}