module "private-alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "eks-nonprod-traefik-private"

  load_balancer_type = "application"

  vpc_id             = local.vpc_id
  subnets            = local.private_subnets
  security_groups    = local.private_sg

  access_logs = {
    bucket = local.alb-log-bucket
  }

  internal = true

  target_groups = [
    {
      name      = "traefik-eks-edge-private"
      backend_protocol = "HTTP"
      backend_port     = local.private_nodeport
      target_type      = "instance"
      targets = [
          for i in local.k8s-edge-node-instances : {
            target_id = i
            port = local.private_nodeport
      }]
      health_check = {
          path = "/dashboard/"
          port = local.private_nodeport
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = local.certificate-arn
      target_group_index = 0
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  tags = {
    Environment = "NonProd"
    Traffic-Type = "Private"
  }
}