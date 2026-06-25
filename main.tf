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

# EC2 Instance to host the website
resource "aws_instance" "web_server" {
  ami           = var.ami
  instance_type = var.instance_type
  user_data     = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y httpd mod_ssl
              systemctl start httpd
              systemctl enable httpd
              aws s3 sync s3://${aws_s3_bucket.ws_bucket.bucket} /var/www/html/
              EOF

  # Ensure the EC2 instance is created after the S3 bucket and its contents are uploaded
  depends_on = [aws_s3_bucket.ws_bucket]
  tags = {
    Name = var.name
  }
}
resource "aws_security_group" "web_sg" {
  name        = "${var.name}-sg"
  description = "Allow HTTP and HTTPS traffic"

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-sg"
  }
}

