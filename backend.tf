terraform {
  backend "s3" {
    bucket  = "my-secure-s3-bucket-593"
    key     = "terraform/tf-state"
    region  = "us-east-1"
    encrypt = true
  }
}