# outputs.tf
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.Terraform_scale_vpc.id
}

output "public_subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.Terraform_scale_public_subnet.id
}

output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.Terraform_scale_private_subnet.id
}
