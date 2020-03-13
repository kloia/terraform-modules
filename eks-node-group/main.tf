locals {
  # Merge defaults and per-group values to make code cleaner
  node_groups_expanded = { for k, v in var.node_groups : k => v
  }
}


data "aws_subnet_ids" "private" {
  vpc_id = var.vpc_id

  tags = {
    Subnet = "Private"
  }
}

resource "aws_eks_node_group" "eks_nodegroup" {
  for_each = local.node_groups_expanded



  cluster_name    = var.cluster_name
  node_group_name = each.key
  node_role_arn   = var.node_role_arn
  subnet_ids      = data.aws_subnet_ids.private.ids
  disk_size       = each.value["node_group_disk_size"]
  instance_types  = each.value["node_group_instance_type"]
  version         = each.value["node_group_version"]
  release_version = each.value["node_group_release_version"]

  scaling_config {
    desired_size = each.value["desired_capacity"]
    max_size     = each.value["max_capacity"]
    min_size     = each.value["min_capacity"]
  }


  dynamic "remote_access" {
    for_each = each.value["key_name"] != null && each.value["key_name"] != "" ? ["true"] : []


    content {
      ec2_ssh_key               = each.value["key_name"]
      source_security_group_ids = each.value["source_security_group_ids"]
    }
  }


  depends_on = [
    var.cluster_endpoint,
  ]

  labels = each.value["kubernetes_labels"]

  tags = merge(
    {
      "Name"         = each.key
      "Cluster_Name" = format("%s", var.cluster_name)
    },
    each.value["tags"],
  )

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

}
