resource "aws_s3_bucket" "terraform_state" {
  bucket = "my-terraform-state-bucket-wk21"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_policy" "terraform_policy" {
  bucket = "my-terraform-state-bucket-wk21"
  policy = file("bucketpolicy.json")
}

resource "aws_s3_bucket_acl" "terraform_acl" {
  bucket = "my-terraform-state-bucket-wk21"
  acl    = "private"
}

resource "aws_dynamodb_table" "terraform_lock" {
  name     = "my-terraform-state-lock"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  billing_mode = "PAY_PER_REQUEST"
}