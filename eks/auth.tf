data "aws_eks_cluster_auth" "cluster_auth" {
  name = var.cluster_name
}


resource "null_resource" "wait_for_eks" {

  depends_on = [
    aws_eks_cluster.eks
  ]

  provisioner "local-exec" {
    command = "until wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null; do sleep 4; done"
    environment = {
      ENDPOINT = aws_eks_cluster.eks.endpoint
    }
  }
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster_auth.token
  load_config_file       = false
}

data "template_file" "node_group_arns" {
  count    = length(var.map_roles)
  template = file("${path.module}/templates/worker-role.tpl")

  vars = {
    worker_role_arn = aws_iam_role.eks_worker_role.arn
  }

}

resource "kubernetes_config_map" "aws_auth_configmap" {
  depends_on = [null_resource.wait_for_eks]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<EOF
${join("", concat(data.template_file.node_group_arns.*.rendered))}
%{if length(var.map_roles) != 0}${yamlencode(var.map_roles)}%{endif}
    EOF
    mapUsers = yamlencode(var.map_users)
  }
}
