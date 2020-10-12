
resource "aws_iam_role" "ecs-host-role" {
  name               = var.aws_iam_role_name
  #assume_role_policy = file("policies/ecs-role.json")
  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
            "ecs.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "ecs-instance-role-policy" {
  name   = var.iam_policy_name
 # policy = file("policies/ecs-instance-role-policy.json")
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
        "Effect": "Allow",
        "Action": [
          "ecs:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "ecr:*",
          "cloudwatch:*",
          "s3:*",
          "rds:*",
          "logs:*"
       ],
        "Resource": "*"
    }
    ]
  }
  EOF

  role   = aws_iam_role.ecs-host-role.id
}

resource "aws_iam_role" "ecs-service-role" {
  name               = var.iam_role_service_name
  #assume_role_policy = file("policies/ecs-role.json")
  assume_role_policy = <<EOF
{
    "Version": "2008-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": [
            "ecs.amazonaws.com",
            "ec2.amazonaws.com"
          ]
        },
        "Effect": "Allow"
      }
    ]
  }
  EOF

}

resource "aws_iam_role_policy" "ecs-service-role-policy" {
  name   = var.service_role_policy_name
  #policy = file("policies/ecs-service-role-policy.json")
  role   = aws_iam_role.ecs-service-role.id
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "elasticloadbalancing:Describe*",
          "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
          "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
          "ec2:Describe*",
          "ec2:AuthorizeSecurityGroupIngress",
          "elasticloadbalancing:RegisterTargets",
          "elasticloadbalancing:DeregisterTargets"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  }
  EOF
  
}

resource "aws_iam_instance_profile" "ecs" {
  name = var.instanceprofile_name
  path = "/"
  role = aws_iam_role.ecs-host-role.name
}
