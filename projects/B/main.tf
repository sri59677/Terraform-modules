provider "aws" {
      region     = var.region
      #access_key = var.access_key
      #secret_key = var.secret_key
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-5961"
    key = "terraform/ECS123"
    region = "eu-west-2"
  }
}




module "ecsmodule" {
    source = "../../modules/ECS"

    vpc_id = var.vpc_id
    existed_subnet_id1 = var.existed_subnet_id1
    existed_subnet_id2 = var.existed_subnet_id2
    existed_subnet_id3 = var.existed_subnet_id3
    amis = var.amis
    region = var.region
    instance_type = var.instance_type
    key_pair = var.key_pair
    autoscale_min = var.autoscale_min
    autoscale_max = var.autoscale_max
    autoscale_desired = var.autoscale_desired
    #autoscale_tag_name = ""
    ecs_cluster_name = var.ecs_cluster_name
    task_definition_path_connop = var.task_definition_path
    docker_image_url_connop = var.docker_image_url_connop
    app_count = var.app_count
    ecs_task_family = var.ecs_task_family
    ecs_container_name = var.ecs_container_name
    container_port = var.container_port
    aws_iam_role_name = var.aws_iam_role_name
    iam_policy_name = var.iam_policy_name
    iam_role_service_name = var.iam_role_service_name
    service_role_policy_name = var.service_role_policy_name
    instanceprofile_name = var.instanceprofile_name

    
}
