 vpc_id = "vpc-e53c6b8d"
 existed_subnet_id1 = "subnet-4c540d25"
 existed_subnet_id2 = "subnet-cf56fe83"
 existed_subnet_id3 = "subnet-e404619e"
 amis = {eu-west-2 = "ami-038863f4c20d2d63d"}
 region = "eu-west-2"
 instance_type = "t2.micro"
 key_pair = "uk"
 autoscale_min = "1"
 autoscale_max = "2"
 autoscale_desired = "1"
 #autoscale_tag_name = ""
 ecs_cluster_name = "mytest"
 task_definition_path = "django_app1.json.tpl"
 docker_image_url_connop = "487468996124.dkr.ecr.eu-west-2.amazonaws.com/my-first-ecr-repo:latest"
 app_count = "2"
 ecs_task_family = "conop-app"
 ecs_container_name = "conop-app"
 container_port = "4000"
 aws_iam_role_name = "ecs_host_role_prod"
 iam_policy_name = "ecs_instance_role_policy"
 iam_role_service_name = "ecs_service_role_prod"
 service_role_policy_name = "ecs_service_role_policy"
 instanceprofile_name = "ecs_instance_profile_prod"

 # Backend Tf State store s3 variables

 bucketname = "terraform-backend-5961"

 bucket_key = "terraform/ECS123"