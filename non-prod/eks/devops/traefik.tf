resource "helm_release" "nonprod-traefik-devops" {
  name       = "nonprod-traefik-devops"
  namespace  = kubernetes_namespace.devops.metadata[0].name
  chart      = "${path.module}/helm/traefik"
  atomic     = true

 values = [
    "${file("${path.module}/helm/traefik/nonprod-devops-values.yaml")}"
  ]
}

resource "helm_release" "nonprod-traefik-private" {
  name       = "nonprod-traefik-private"
  namespace  = kubernetes_namespace.devops.metadata[0].name
  chart      = "${path.module}/helm/traefik"
  atomic     = true

 values = [
    "${file("${path.module}/helm/traefik/nonprod-private-values.yaml")}"
  ]
}

resource "helm_release" "nonprod-traefik-internal" {
  name       = "nonprod-traefik-internal"
  namespace  = kubernetes_namespace.devops.metadata[0].name
  chart      = "${path.module}/helm/traefik"
  atomic     = true

 values = [
    "${file("${path.module}/helm/traefik/nonprod-internal-values.yaml")}"
  ]
}