provider "aws" {
      region     = var.region
      access_key = var.access_key
      secret_key = var.secret_key
}

terraform {
  backend "s3" {
    bucket = "terraform-backend-5961"
    key = "terraform/ECS1234"
    region = "eu-west-2"
  }
}


module "myecsmodule" {
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
    ecs_cluster_name = "mycluster"
    task_definition_path_connop = "django_app.json.tpl"
   # docker_image_url_connop = ""
   # app_count = ""
    ecs_task_family = "my-app"
    ecs_container_name = "my-app"
    container_port = "4000"
    aws_iam_role_name = "myapphostrole"
    iam_policy_name = "myapphostpolicy"
    iam_role_service_name = "servicemyapprole"
    service_role_policy_name = "myapservicepolicy"
    instanceprofile_name = "myapp"

    
}
