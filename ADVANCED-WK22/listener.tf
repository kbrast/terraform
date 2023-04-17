# listener.tf - listener for the ALB
resource "aws_alb_listener" "web_alb_listener" {
  load_balancer_arn = aws_alb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.web_target_group.arn
  }
}