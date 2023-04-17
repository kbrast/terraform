# alb_target_group_attachment.tf - target group attachment for the ALB
resource "aws_alb_target_group_attachment" "web_target_group_attachment_1" {
  target_group_arn = aws_alb_target_group.web_target_group.arn
  target_id        = aws_instance.web_server.id
  port             = 80
}

resource "aws_alb_target_group_attachment" "web_target_group_attachment_2" {
  target_group_arn = aws_alb_target_group.web_target_group.arn
  target_id        = aws_instance.web_server_2.id
  port             = 80
}