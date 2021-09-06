resource "aws_security_group" "eks_cluster_controlplane" {
  name        = "nonprod-eks-control-plane"
  description = "Allow inbound traffic for EKS control plane"
  vpc_id      = local.vpc_id

  ingress = [
    {
      description      = "TLS from Infra VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["10.x.x.0/24", "10.x.x.0/24"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow VPC access cluster"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["10.0.0.0/8"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow EKS Master"
      from_port = 0
      to_port = 0
      protocol = -1
      self = true
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
    },
    {
      description      = "Allow Master - Worker communication"
      from_port = 0
      to_port = 0
      protocol = -1
      self = null
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = ["sg-xxxxx"]
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-eks_cluster_controlplane"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "eks_cluster_shred_nodegroup" {
  name        = "nonprod-eks-shared-node-group"
  description = "Allow inbound traffic for EKS Node groups"
  vpc_id      = local.vpc_id

  ingress = [
    {
      description      = "Allow EKS Master itself"
      from_port = 0
      to_port = 0
      protocol = -1
      self = true
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
    },
    {
      description      = "Allow Master - Worker communication"
      from_port = 0
      to_port = 0
      protocol = -1
      self = null
      cidr_blocks      = null
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = ["sg-xxxx"]
    },
    {
      description      = "Allow OpenVPN non-prod SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["10.x.0.103/32"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
      self             = null
    },
    {
      description      = "Allow ALB to access DevOps Traefik NodePort"
      from_port        = 30800
      to_port          = 30800
      protocol         = "tcp"
      cidr_blocks      = ["10.x.0.0/23"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = ["sg-xxxxx"]
      self             = null
    },
    {
      description      = "Allow ALB to access Internal Traefik NodePort"
      from_port        = 30700
      to_port          = 30700
      protocol         = "tcp"
      cidr_blocks      = ["10.x.0.0/23"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = ["sg-xxxxxx"]
      self             = null
    },
    {
      description      = "Allow ALB to access Private Traefik NodePort"
      from_port        = 30900
      to_port          = 30900
      protocol         = "tcp"
      cidr_blocks      = ["10.x.0.0/23"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = ["sg-xxxxxx"]
      self             = null
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-eks_cluster_shred_nodegroup"
    ManagedBy = "Terraform"
  }
}