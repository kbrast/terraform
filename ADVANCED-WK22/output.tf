# output.tf - ALB public DNS name
output "alb_dns_name" {
  value = aws_alb.web_alb.dns_name
}