//policy curl -o example-iam-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/v1.0.0/docs/example-iam-policy.json
resource "kubernetes_service_account" "ebs-csi-controller" {
  metadata {
    annotations = {
        "eks.amazonaws.com/role-arn" = "arn:aws:iam::xxxx:policy/AmazonEKS_EBS_CSI_Driver_Policy"
     }
    namespace = "kube-system"
    //default SA name in chart
    name = "ebs-csi-controller-sa"
  }
}

data "helm_repository" "ebs" {
  name = "aws-ebs-csi-driver"
  url  = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
}

resource "helm_release" "ebs-csi-controller" {
  name       = "ebs-csi-controller"
  namespace  = "kube-system"
  repository = data.helm_repository.ebs.metadata[0].name
  chart      = "aws-ebs-csi-driver"
  version    = "2.1.0"
  atomic     = true

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.ap-southeast-1.amazonaws.com/eks/aws-ebs-csi-driver"
  }

  set {
    name  = "enableVolumeResizing"
    value = true
  }

  set {
    name  = "enableVolumeSnapshot"
    value = true
  }

  set {
    name  = "controller.serviceAccount.create"
    value = false
  }
}