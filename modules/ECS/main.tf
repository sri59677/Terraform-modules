########################################
# CReating a LoadBalancer for conop
########################################

# load balancer for conop-ecs
resource "aws_alb" "con-ute-v1-conop-alb" {
    load_balancer_type = "application"
    idle_timeout    = 60
    internal        = false
    name            = "${var.ecs_cluster_name}-alb"
    security_groups = [aws_security_group.conop-sg-alb.id,aws_security_group.con-ute-v1-0-webaccess.id ]
    subnets         = [var.existed_subnet_id1,var.existed_subnet_id2,var.existed_subnet_id3]

    enable_deletion_protection = false

    
}

data "aws_vpc" "selected" {
  id = var.vpc_id
}



resource "aws_security_group" "conop-sg-alb" {
   name        = "${var.ecs_cluster_name}-sg-alb"
   description = "con-ute-v1.0-conop-sg-alb"
   vpc_id      = var.vpc_id

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }


    egress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }

    egress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }




  tags = {
    Name = "${var.ecs_cluster_name}-sg-alb"
  }
}


resource "aws_security_group" "con-ute-v1-0-webaccess" {
    name        = "${var.ecs_cluster_name}-webaccess"
    description = "con-ute-v1.0-webaccess"
    vpc_id      = var.vpc_id

    ingress {
        from_port       = 80
        to_port         = 80
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }

    ingress {
        from_port       = 22
        to_port         = 22
        protocol        = "tcp"
        cidr_blocks     = ["${data.aws_vpc.selected.cidr_block}"]
    }

    ingress {
        from_port       = 1
        to_port         = 65535
        protocol        = "tcp"
        security_groups = [aws_security_group.conop-sg-alb.id]
        self            = false
    }

    ingress {
        from_port       = 443
        to_port         = 443
        protocol        = "tcp"
        cidr_blocks     = ["0.0.0.0/0"]
        ipv6_cidr_blocks     = ["::/0"]
    }


    egress {
        from_port       = 0
        to_port         = 0
        protocol        = "-1"
        cidr_blocks     = ["0.0.0.0/0"]
    }

    tags = {
        Name = "webaccess"
    }
}


resource "aws_lb_target_group" "tg-conop-ecs" {
  health_check {
    interval            = 10
    path                = "/"
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  name        = "${var.ecs_cluster_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}



# Listener (redirects traffic from the load balancer to the target group)
resource "aws_alb_listener" "conop-ecs-alb-http-listener" {
  load_balancer_arn = aws_alb.con-ute-v1-conop-alb.id
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.tg-conop-ecs]

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-conop-ecs.arn
  }
}

/*
# Listener (redirects traffic from the load balancer to the target group)
resource "aws_alb_listener" "ecs-alb-http-listener" {
  load_balancer_arn = aws_lb.con-ute-v1-conop-alb.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn
  depends_on        = [aws_alb_target_group.tg-conop-ecs]

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.tg-conop-ecs.arn
  }
}
*/


#####################################
# Creating Launch_configuration
#####################################

# launch configuration for Conop-ECS
resource "aws_launch_configuration" "conop-ecs-launchconfig" {
  name                        = "${var.ecs_cluster_name}-cluster-ec2-lanuchconfig"  # Name of the Lanuch Configuration
  image_id                    = lookup(var.amis, var.region)
  instance_type               = var.instance_type
  security_groups             = [aws_security_group.con-sg-ecs.id]  # Attaching Security-Group
  iam_instance_profile        = aws_iam_instance_profile.ecs.name   # Referencing Iam role

  root_block_device {
      volume_type = "gp2"
      volume_size = 30
      delete_on_termination = true
    }

  key_name                    = var.key_pair    # Key_pair Name to SSH into our instance
  associate_public_ip_address = true     # Assigning Public IP

  user_data                   = "#!/bin/bash\necho ECS_CLUSTER='${var.ecs_cluster_name}-cluster' > /etc/ecs/ecs.config"

  }


  resource "aws_security_group" "con-sg-ecs" {
  name        = "${var.ecs_cluster_name}-ec2-sg"
  description = "Rules for ecs for ute conop"
  vpc_id      = var.vpc_id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks   = ["::/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks   = ["::/0"]
  }

  ingress {
        from_port       = 1
        to_port         = 65535
        protocol        = "tcp"
        security_groups = [aws_security_group.conop-sg-alb.id]
        self            = false
    }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.aws_vpc.selected.cidr_block}"]
  }
  egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-ec2-${var.ecs_cluster_name}"
  }
}



  #####################################
  # Auto Scaling Group
  #####################################

  resource "aws_autoscaling_group" "conop-ecs-cluster-asg" {
  name                 = "${var.ecs_cluster_name}-autoscalinggroup"
  min_size             = var.autoscale_min
  max_size             = var.autoscale_max
  desired_capacity     = var.autoscale_desired
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.conop-ecs-launchconfig.name
  vpc_zone_identifier  = [var.existed_subnet_id1,var.existed_subnet_id3]
  
  tag {
        key   = "Description"
        value = "This instance is the part of the Auto Scaling group which was created through ECS Console"
        propagate_at_launch = true
    }

  tag {
        key   = "Name"
        value = var.autoscale_tag_name
        propagate_at_launch = true
    }

}


/* #############################################
 Connop Cluster Creation
 ############################################# */

resource "aws_ecs_cluster" "connop" {
  name = "${var.ecs_cluster_name}-cluster"      # Cluster Name
  
  #container_insights = true
}

data "template_file" "app-connop" {
  template = file("${var.task_definition_path_connop}")    # Path of json- Task Definition

  vars = {
    docker_image_url_connop = var.docker_image_url_connop
    region                  = var.region
  }
}

# Creating Task Definition
resource "aws_ecs_task_definition" "app-connop" {
  family                = var.ecs_task_family                  # ECS Task definition family name
  container_definitions = data.template_file.app-connop.rendered
}

# Creating Service Definition for ECS
resource "aws_ecs_service" "connop" {
  name            = "${var.ecs_cluster_name}-service"     # Name for ecs service
  cluster         = aws_ecs_cluster.connop.id
  task_definition = aws_ecs_task_definition.app-connop.arn
  iam_role        = aws_iam_role.ecs-service-role.arn
  desired_count   = var.app_count                         # Number of containers to Deploy
  depends_on      = [aws_alb_listener.conop-ecs-alb-http-listener, aws_iam_role_policy.ecs-service-role-policy]


  load_balancer {
    target_group_arn = aws_lb_target_group.tg-conop-ecs.arn   # Referencing Target Group
    container_name   = var.ecs_container_name         # Container name
    container_port   = var.container_port                 # Port Number of Container
  }
}


/*resource "aws_iam_role" "ecs-host-role" {
  name               = "ecs_host_role_prod"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-role}"
}

data "aws_iam_policy_document" "ecs-role" {
    

    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type  = "Service"
            identifiers = ["ec2.amazonaws.com", "ecs.amazonaws.com"]
        }

        effect = "Allow"
    }
}
*/
      