output "eks_cluster_endpoint" {
  description = "Eks cluster endpoint"
  value       = aws_eks_cluster.eks.endpoint
}
