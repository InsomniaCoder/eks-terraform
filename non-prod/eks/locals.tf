locals {
  aws_region = yamldecode(file("cluster_values.yaml"))["region"]
  custom_tags = merge(
    yamldecode(file("../../global_tags.yaml")),
    yamldecode(file("../env_tags.yaml"))
  )

  //eks
  kubernetes_version = yamldecode(file("cluster_values.yaml"))["kubernetes_version"]
  cluster_name = yamldecode(file("cluster_values.yaml"))["eks-name"]
  vpc_id = yamldecode(file("cluster_values.yaml"))["vpc_id"]
  private_subnets = yamldecode(file("cluster_values.yaml"))["private_subnets"]
  pod_subnets = yamldecode(file("cluster_values.yaml"))["pod_subnets"]
  
  master_sg = yamldecode(file("cluster_values.yaml"))["eks_master_sg"]
  worker_sg = yamldecode(file("cluster_values.yaml"))["eks_node_sg"]
  //worker node
  worker_node_type = yamldecode(file("cluster_values.yaml"))["worker_node_type"]
  worker_node_max  = yamldecode(file("cluster_values.yaml"))["worker_node_max"]
  worker_node_min  = yamldecode(file("cluster_values.yaml"))["worker_node_min"]
  worker_node_desire = yamldecode(file("cluster_values.yaml"))["worker_node_desire"]
  //devops node
  devops_node_type = yamldecode(file("cluster_values.yaml"))["devops_node_type"]
  devops_node_max  = yamldecode(file("cluster_values.yaml"))["devops_node_max"]
  devops_node_min  = yamldecode(file("cluster_values.yaml"))["devops_node_min"]
  devops_node_desire = yamldecode(file("cluster_values.yaml"))["devops_node_desire"]
  //edge node
  edge_node_type = yamldecode(file("cluster_values.yaml"))["edge_node_type"]
  edge_node_max  = yamldecode(file("cluster_values.yaml"))["edge_node_max"]
  edge_node_min  = yamldecode(file("cluster_values.yaml"))["edge_node_min"]
  edge_node_desire = yamldecode(file("cluster_values.yaml"))["edge_node_desire"]
}