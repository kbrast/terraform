variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id" {
  default = "<your-default-vpc_id>"
}

variable "subnet_ids" {
  type    = list(string)
  default = ["<your-subnet-a>", "<your-subnet-b>"]
}

variable "key_name" {
  default = "<your-key>"
}