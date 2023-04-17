# alb.tf - Application Load Balancer resource
resource "aws_alb" "web_alb" {
  name = "web-alb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_sg.id]
  subnets = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
  tags = {
    Name = "Web Application Load Balancer"
  }
  lifecycle {
    create_before_destroy = true
  }
}