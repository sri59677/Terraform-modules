provider "aws" {
  region = var.region #V
}

data "aws_availability_zones" "available" {}