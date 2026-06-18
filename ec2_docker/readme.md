# EC2 Docker Setup

This repository contains Terraform configuration to provision an AWS EC2 instance and install Docker on it.

## Files

- `main.tf` - EC2 and Docker setup resources
- `providers.tf` - AWS provider configuration
- `variable.tf` - input variables
- `output.tf` - outputs from the deployment
- `scripts/install_docker.sh` - installs Docker on the EC2 instance

## Usage

1. Update AWS credentials and region.
2. Run `terraform init`.
3. Run `terraform apply`.

## Notes

- `terraform destroy` removes the created infrastructure.
- Ensure the EC2 instance has proper SSH and security group settings.
