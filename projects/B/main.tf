provider "aws" {
      region     = var.region
      access_key = var.access_key
      secret_key = var.secret_key
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

   # vpc_id = ""
   # existed_subnet_id1 = ""
   # existed_subnet_id2 = ""
   # existed_subnet_id3 = ""
   # amis = ""
   # region = ""
   # instance_type = ""
   # key_pair = ""
   # autoscale_min = ""
   # autoscale_max = ""
   # autoscale_desired = ""
   # autoscale_tag_name = ""
   # ecs_cluster_name = ""
    task_definition_path_connop = "django_app1.json.tpl"
   # docker_image_url_connop = ""
   # app_count = ""
   # ecs_task_family = ""
   # ecs_container_name = ""
   # container_port = ""
   #aws_iam_role_name = ""
    #iam_policy_name = ""
    #iam_role_service_name = ""
    #service_role_policy_name = ""
    #instanceprofile_name = ""

    
}
