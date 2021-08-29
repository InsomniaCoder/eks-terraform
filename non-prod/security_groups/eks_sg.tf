resource "aws_security_group" "eks_cluster_controlplane" {
  name        = "nonprod-eks-control-plane"
  description = "Allow inbound traffic for EKS control plane"
  vpc_id      = local.vpc_id

  ingress = [
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
      security_groups  = ["sg-xxxx"]
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
      cidr_blocks      = ["x.x.x.x/32"]
      ipv6_cidr_blocks = null
      prefix_list_ids  = null
      security_groups  = null
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