provider "aws" {
  region = local.aws_region
}

provider "kubernetes" {
  experiments {
    manifest_resource = true
  }
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

provider "helm" {
  kubernetes {
    config_path = "./kubeconfig-nonprod"
  }
  // use this version as the last version that have helm_repository block to prevent cache
  version = "1.3.2"
}