
variable "region" {
    type =string
    default = "ap-south-1"
}

variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}

variable "cluster-access-cidrblock" {
    default = "10.0.0.0/16"
    type = string
}

variable "vpc_id" {
    type = string
    default = "vpc-a4525fcc"
    
}

variable "subnet_ids" {
    type = list(string)
    default = ["subnet-4d7ce401", "subnet-aab416d1", "subnet-db91bab3"]
}

variable "disk_size" {
    type = number
    default = 30
}

variable "desired_size" {
    type = number
    default = 2
}
variable "max_size" {
    type = number
    default = 3
}
variable "min_size" {
    type = number
    default = 1
}
variable "instance_type" {
    type = string
    default = "t2.micro"
}
variable "keypair_name" {
    type = string
    default = "python"
}
variable "workernodes_securitygroup" {
    type = string
    default = "sg-9da7f7fc"
}




