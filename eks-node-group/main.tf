data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  tags = {
    Subnet = "Private"
  }
}



resource "random_id" "suffix" {
  byte_length = 4


  keepers = {
    disk_size      = var.node_group_disk_size
    instance_types = join("|", var.node_group_instance_type)
    node_role_name = var.node_role_name

    ec2_ssh_key               = var.key_name
    source_security_group_ids = join("|", var.source_security_group_ids)

    subnet_ids   = join("|", data.aws_subnet_ids.private.ids)
    cluster_name = var.cluster_name
  }
}


resource "aws_eks_node_group" "eks_nodegroup" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name == "" ? join("-", [var.cluster_name, random_id.suffix.hex]) : var.node_group_name
  node_role_arn   = aws_iam_role.eks_worker_role.arn
  subnet_ids      = data.aws_subnet_ids.private.ids
  disk_size       = var.node_group_disk_size
  instance_types  = var.node_group_instance_type

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_capacity
    min_size     = var.min_capacity
  }


  dynamic "remote_access" {
    for_each = var.key_name != null && var.key_name != "" ? ["true"] : []
    content {
      ec2_ssh_key               = var.key_name
      source_security_group_ids = var.source_security_group_ids
    }
  }


  depends_on = [
    var.cluster_endpoint,
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_worker_node_AmazonEC2ContainerRegistryReadOnly,
  ]

  labels = var.kubernetes_labels

  tags = merge(
    {
      "Name"         = format("%s", var.node_group_name == "" ? join("-", [var.cluster_name, random_id.suffix.hex]) : var.node_group_name)
      "Cluster_Name" = format("%s", var.cluster_name)
    },
    var.tags,
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

}

resource "aws_iam_role" "eks_worker_role" {
  name = join("-", [var.node_role_name, random_id.suffix.hex])

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  tags = merge(
    {
      "Name" = format("%s", var.cluster_name)
    },
    var.tags,
  )
}


resource "aws_iam_role_policy_attachment" "eks_worker_node_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_role.name
}
