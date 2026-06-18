output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.ec2_docker.public_ip
}

output "ssh_command" {
  description = "Command to SSH into the instance"
  value       = "ssh -i \"${var.key_name}.pem\" ubuntu@${aws_instance.ec2_docker.public_dns}"
}