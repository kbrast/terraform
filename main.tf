variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = "vpc-xxxxxxxx"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]
}

variable "key_name" {
  default = "my-key"
}

variable "bucket_name" {
  default = "my-bucket"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow HTTP traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "webserver" {
  name          = "webserver"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  security_groups = [aws_security_group.allow_http.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              service httpd start
              chkconfig httpd on
              echo "<html><body><h1>Hello World</h1></body></html>" > /var/www/html/index.html
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "webserver_asg" {
  name                      = "webserver_asg"
  launch_configuration      = aws_launch_configuration.webserver.name
  min_size                  = 2
  max_size                  = 5
  health_check_grace_period = 300
  health_check_type         = "ELB"

  vpc_zone_identifier       = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "webserver_asg_instance"
    propagate_at_launch = true
  }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.bucket_name
}

resource "aws_lb" "webserver_alb" {
  name               = "webserver-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_http_alb.id]
  subnets            = var.subnet_ids
}

resource "aws_lb_target_group" "webserver_tg" {
  name     = "webserver-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "webserver_listener" {
  load_balancer_arn = aws_lb.webserver_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webserver_tg.arn
  }
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.webserver_asg.id
  alb_target_group_arn   = aws_lb_target_group.webserver_tg.arn
}

resource "aws_security_group" "allow_http_alb" {
  name        = "allow_http_alb"
  description = "Allow HTTP traffic to ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "allow_http_from_alb" {
  security_group_id        = aws_security_group.allow_http.id
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.allow_http_alb.id
}

output "alb_dns_name" {
  value = aws_lb.webserver_alb.dns_name
}

terraform {
  backend "s3" {
    bucket = var.bucket_name
    key    = "terraform.tfstate"
    region = var.aws_region
  }
}