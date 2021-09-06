locals {
  aws_region = yamldecode(file("alb_values.yaml"))["region"]
  custom_tags = merge(
    yamldecode(file("../../global_tags.yaml")),
    yamldecode(file("../env_tags.yaml"))
  )
  certificate-arn = yamldecode(file("alb_values.yaml"))["certificate-arn"]
  k8s-edge-node-instances = yamldecode(file("alb_values.yaml"))["k8s-edge-node-instances"]
  alb-log-bucket = yamldecode(file("alb_values.yaml"))["alb-log-bucket"]

  vpc_id = yamldecode(file("alb_values.yaml"))["vpc_id"]
  private_subnets = yamldecode(file("alb_values.yaml"))["private_subnets"]

  devops_sg = yamldecode(file("alb_values.yaml"))["traefik-sg-devops"]
  devops_nodeport = yamldecode(file("alb_values.yaml"))["traefik-devops-nodeport"]
  
  internal_sg = yamldecode(file("alb_values.yaml"))["traefik-sg-internal"]
  internal_nodeport = yamldecode(file("alb_values.yaml"))["traefik-internal-nodeport"]
  
  private_sg = yamldecode(file("alb_values.yaml"))["traefik-sg-private"]
  private_nodeport = yamldecode(file("alb_values.yaml"))["traefik-private-nodeport"]
}