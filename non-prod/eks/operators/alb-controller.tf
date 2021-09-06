resource "null_resource" "alb-controller-crd" {
  provisioner "local-exec" {
    command = "kubectl apply -k 'github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master'"
  }
}

//policy curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.2.0/docs/install/iam_policy.json
resource "kubernetes_service_account" "aws-load-balancer-controller" {
  metadata {
    annotations = {
        "eks.amazonaws.com/role-arn" = "arn:aws:iam::xxxx:role/xxxx"
     }
    namespace = "kube-system"
    name = "aws-load-balancer-controller"
  }
}

data "helm_repository" "eks" {
  name = "eks"
  url  = "https://aws.github.io/eks-charts"
}

resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  namespace  = "kube-system"
  repository = data.helm_repository.eks.metadata[0].name
  chart      = "eks/aws-load-balancer-controller"
  version    = "1.2.7"
  atomic     = true

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "logLevel"
    value = "debug"
  }

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
}