resource "aws_eks_cluster" "cluster" {
  name = "${var.site}-${var.user}-cls"
  role_arn = data.aws_iam_role.eks-role.arn


  vpc_config {
    subnet_ids = [
      aws_subnet.priv1.id,
      aws_subnet.priv2.id,
      aws_subnet.pub1.id,
      aws_subnet.pub2.id
    ]
  }
}

resource "aws_eks_node_group" "nodes" {
  cluster_name = aws_eks_cluster.cluster.name
  node_group_name = "${var.site}-${var.user}-nodes"
  node_role_arn = data.aws_iam_role.node-role.arn

  subnet_ids = [
    aws_subnet.priv1.id,
    aws_subnet.priv2.id
  ]

  capacity_type = "ON_DEMAND"
  instance_types = ["t3.small"]
  scaling_config {
    desired_size = 2
    max_size = 2
    min_size = 2
  }
  update_config {
    max_unavailable = 1
  }
}

# Si OIDC autorisé
# data "tls_certificate" "eks" {
#   url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
# }
# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list = [ "sts.amazonaws.com" ]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#   url = aws_eks_cluster.cluster.identity[0].oidc[0].issuer
# }

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
    "app.kubernetes.io/name"      = "aws-load-balancer-controller"
    "app.kubernetes.io/component" = "controller"
    }
    annotations = {
    "eks.amazonaws.com/role-arn" = "arn:aws:iam::019050461780:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing"
    "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

resource "helm_release" "lb" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.service-account
  ]

  set {
    name  = "region"
    value = "eu-west-1"
  }

  set {
    name  = "vpcId"
    value = data.aws_vpc.vpc.id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = aws_eks_cluster.cluster.name
  }
}