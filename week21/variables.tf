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