output "bucket_name" {
  description = "Bucket global unique name"
  value = aws_s3_bucket.ws_bucket.id
}
output "instance_id" {
  description = "The ID of the created EC2 instance"
  value       = aws_instance.web_server.public_dns
}