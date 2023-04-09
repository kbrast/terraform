terraform {
  backend "s3" {
    bucket = "my-terraform-state-bucket-wk21"
    key    = "terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "my-terraform-state-lock"
    encrypt        = true
  }
}