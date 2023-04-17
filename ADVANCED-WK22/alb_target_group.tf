# alb_target_group.tf - Target Group resource
resource "aws_alb_target_group" "web_target_group" {
  name        = "web-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.my_vpc.id

  health_check {
    path     = "/"
    port     = 80
    protocol = "HTTP"
  }

  lifecycle {
    create_before_destroy = true
  }
}