locals {
  aws_region = yamldecode(file("sg_values.yaml"))["region"]
  custom_tags = merge(
    yamldecode(file("../../global_tags.yaml")),
    yamldecode(file("../env_tags.yaml"))
  )

  vpc_id = yamldecode(file("sg_values.yaml"))["vpc_id"]
}