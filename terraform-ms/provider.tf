provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      owner = "kbillerach@thenuumfactory.fr"
      ephemere = "non"
      entity = "numfactory"
    }
  }
}

provider "kubernetes" {
  host = aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data) 
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [ "eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.name ]
  }
}

provider "helm" {
  kubernetes {
    host = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = [ "eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.name ]
  }
  }
}

terraform {
  backend "s3" {
    bucket = "kebi-s3"
    key = "microservice.tfstate"
    region = "eu-west-1"
  }
}