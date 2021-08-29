module "eks" {
  source = "terraform-aws-modules/eks/aws"

  tags = merge(
    local.custom_tags
  )

  cluster_name                         = local.cluster_name
  cluster_iam_role_name                = "eks-nonprod-cluster-role"
  
  vpc_id                               = local.vpc_id
  subnets                              = local.private_subnets
  
  cluster_endpoint_public_access       = false
  cluster_endpoint_private_access      = true
  cluster_endpoint_private_access_cidrs = ["${local.master_sg}"]
  cluster_create_security_group        = false
  cluster_security_group_id            = local.master_sg

  write_kubeconfig                     = true

  enable_irsa                          = true
  kubeconfig_aws_authenticator_command = "aws"
  kubeconfig_aws_authenticator_command_args = [
    "eks",
    "get-token",
    "--cluster-name",
    local.cluster_name
  ]
  map_roles = [
  {
    "groups": [ "system:masters" ],
    "rolearn": "arn:aws:iam::xxxx:role/Admin",
    "username": "eks-admin-nonprod"
  }
]
  kubeconfig_aws_authenticator_additional_args = []

  cluster_version           = local.kubernetes_version
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  workers_role_name = "eks-nonprod-worker-role"
  worker_create_security_group = false
  worker_security_group_id = local.worker_sg
  worker_additional_security_group_ids = ["${local.worker_sg}"]

  node_groups = {
    "${local.cluster_name}-edge-node" = {
      create_launch_template = true
      capacity_type = "ON_DEMAND"
      name                   = "${local.cluster_name}-edge-node"

      desired_capacity       = local.edge_node_desire
      max_capacity           = local.edge_node_max
      min_capacity           = local.edge_node_min

      instance_types         = ["${local.edge_node_type}"]
      disk_size              = 50
      
      key_name               = "monix-general-key"
      
      //kubelet_extra_args     = "--use-max-pods false --max-pods=20"
      
      k8s_labels = {
        pool = "edge"
        dedicated	= "edgenode"
        edgenode= "true"
        env= "nonprod"
      }

      taints = [
        {
         "key": "edgenode",
         "value": "true",
         "effect": "NO_SCHEDULE"
        }
      ]
    }

     "${local.cluster_name}-devops-node" = {
      create_launch_template = true
      capacity_type = "ON_DEMAND"
      name                   = "${local.cluster_name}-devops-node"

      desired_capacity       = local.devops_node_desire
      max_capacity           = local.devops_node_max
      min_capacity           = local.devops_node_min
      instance_types         = ["${local.devops_node_type}"]

      disk_type              = "gp3"
      disk_size              = 50
      
      //kubelet_extra_args     = "--use-max-pods false --max-pods=50"
      k8s_labels = {
        pool = "devops"
        dedicated	= "app"
        env= "nonprod"
      }
      capacity_type = "ON_DEMAND"
    }

    // "${local.cluster_name}-worker" = {
    //   create_launch_template = true
    //   desired_capacity       = local.worker_node_desire
    //   max_capacity           = local.worker_node_max
    //   min_capacity           = local.worker_node_min
    //   instance_types         = ["${local.worker_node_type}"]
    
    //   disk_size              = 100
    //   kubelet_extra_args     = "--use-max-pods false --max-pods=50"
    //   k8s_labels = {
    //     pool = "worker"
    //     dedicated	= "app"
    //     env= "nonprod"
    //   }
    //   capacity_type = "ON_DEMAND"
    // }
  }
}

output "eks" {
  value = module.eks
}
