/*variable "access_key" {
     description = "Access key to AWS console"
     
}
variable "secret_key" {
     description = "Secret key to AWS console"
     
}*/

variable "region" {
  default     = "eu-west-2"
  type        = string
  description = "Region of the VPC"
}

variable "vpc_id" {
  description = "enter a existed or desired vpc id"
  default     = "vpc-e53c6b8d"
} 


########################################
########### Load Balncer Variables ######
########################################

# Subnet ID's across which subnets you want to deploy laodbalancer

variable "existed_subnet_id1" {
  description = "enter a existed or desired Subnet id"
  default     = "subnet-4c540d25"

}

variable "existed_subnet_id2" {
  description = "enter a existed or desired Subnet id"
  default     = "subnet-cf56fe83"

}

variable "existed_subnet_id3" {
  description = "enter a existed or desired Subnet id"
  default     = "subnet-e404619e"

}

# Target Group 

variable "Target_group_name" {
  description = "target group name"
  default     = "con-ute-v1-tg-conop-ecs"
}

# Launch_Configuration

variable "amis" {
  description = "Which AMI to spawn."
  default = {
    #ap-southeast-2 = "ami-095016ddc8e84b54e"
    eu-west-2 = "ami-038863f4c20d2d63d"
  }
}
variable "instance_type" {
  default = "t2.micro"
}




variable "key_pair" {
  description = "Key Pair name which was already created under the AWS account with-in the same region"
  default = "uk" #Should be created on the AWS account before using it 

}

# Auto Scaling variables

variable "autoscaling_name" {
    description = " Give a valid name for your autoscaling group"
    default     = "ute-conop-ecs-cluster-autoscalinggroup"
}

variable "autoscale_min" {
  description = "Minimum autoscale (number of EC2)"
  default     = "1"
}
variable "autoscale_max" {
  description = "Maximum autoscale (number of EC2)"
  default     = "2"
}
variable "autoscale_desired" {
  description = "Desired autoscale (number of EC2)"
  default     = "1"
}

variable "autoscale_tag_name" {
    default = "ECS Instance - EC2ContainerService-ute-conop-ecs-cluster"
}


# ECS Cluster

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  default     = "ute-conop-ecs"                  
}

variable "task_definition_path" {
  description = "path address of task-definitio"
  default     = "django_app1.json.tpl"
}



variable "docker_image_url_connop" {
  description = "Docker image to run in the ECS cluster"
  default     = "487468996124.dkr.ecr.eu-west-2.amazonaws.com/my-first-ecr-repo:latest"
  #"488434573306.dkr.ecr.eu-west-2.amazonaws.com/conop:5bbe5ded7e3bef3e847e27ee79c907c533bcb87c"
}


variable "app_count" {
  description = "Number of Docker containers to run"
  default     = 2
}


variable "ecs_task_family" {
  default = "conop-app"
}

variable "ecs_container_name" {
  default = "conop-app"
}
variable "container_port" {
  default = "4000"
}



variable "aws_iam_role_name" {
  default = "ecs_host_role_prod"
}

variable "iam_policy_name" {
  default = "ecs_instance_role_policy"
}

variable "iam_role_service_name" {
  default = "ecs_service_role_prod"
}

variable "service_role_policy_name" {
  default = "ecs_service_role_policy"
}

variable "instanceprofile_name" {
  default = "ecs_instance_profile_prod"
}

# Backend s3

variable bucketname {
     description = "Enter your bucket name which stores Terraform state files"
}

variable bucket_key {
     description = "give the path inside bucket"
}
