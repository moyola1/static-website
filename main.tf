resource "aws_s3_bucket" "test_bucket" {
  bucket        = "mo-terraform-test-bucket-3412432535"
  force_destroy = true
}