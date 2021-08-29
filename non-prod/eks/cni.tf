resource "kubernetes_manifest" "cni-subnet-a" {
  manifest = {
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"

    metadata = {
      name = "ap-southeast-1a"
    }

    spec = {
      subnet = "${local.pod_subnets[0]}"
      securityGroups = ["${local.worker_sg}"]
    }
  }
}

resource "kubernetes_manifest" "cni-subnet-b" {
  manifest = {
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"

    metadata = {
      name = "ap-southeast-1b"
    }

    spec = {
      subnet = "${local.pod_subnets[1]}"
      securityGroups = ["${local.worker_sg}"]
    }
  }
}


resource "kubernetes_manifest" "cni-subnet-c" {
  manifest = {
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"

    metadata = {
      name = "ap-southeast-1c"
    }

    spec = {
      subnet = "${local.pod_subnets[2]}"
      securityGroups = ["${local.worker_sg}"]
    }
  }
}

resource "null_resource" "cni-env-set" {
  provisioner "local-exec" {
    command = "kubectl set env daemonset aws-node -n kube-system AWS_VPC_K8S_CNI_CUSTOM_NETWORK_CFG=true && kubectl set env daemonset aws-node -n kube-system ENI_CONFIG_LABEL_DEF=failure-domain.beta.kubernetes.io/zone"
  }
}