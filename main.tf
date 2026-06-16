resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# 1. Create the S3 Bucket
resource "aws_s3_bucket" "ws_bucket" {
  bucket        = "${var.bucket_name}${random_id.bucket_suffix.hex}"
  force_destroy = true
}

# 2. Upload files and subdirectories recursively
resource "aws_s3_object" "upload_assets" {
  for_each = fileset("${path.module}/ocean_vibes/", "**")

  bucket = aws_s3_bucket.ws_bucket.id
  key    = each.value
  source = "${path.module}/ocean_vibes/${each.value}"
  etag   = filemd5("${path.module}/ocean_vibes/${each.value}")
}
