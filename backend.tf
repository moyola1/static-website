terraform {
  backend "s3" {
    bucket  = "my-secure-s3-bucket-593"
    key     = "terraform/tf-state"
    region  = "us-east-1"
    encrypt = true
    # Prevents Terraform backend from being modified by another
    # process while Terraform is running. This is important for team environments.
    use_lockfile = true
  }
}