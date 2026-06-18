data "aws_ami" "ubuntu" {

  owners = ["099720109477"] # Canonical  

  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

data "aws_key_pair" "ssh_key" {
  key_name = var.key_name
}

# Security group and EC2 instance resources

resource "aws_security_group" "ec2_docker_sg" {
  name        = "ec2-docker-sg"
  description = "Allow SSH, HTTP and HTTPS"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
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
    Name = "ec2-docker-sg"
  }
}

# cloud-init to install scripts

data "cloudinit_config" "ec2_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    filename     = "install_docker.sh"
    content      = file("${path.module}/scripts/install_docker.sh")
  }

}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet" "shared_subnet" {
  vpc_id            = data.aws_vpc.default.id
  availability_zone = data.aws_availability_zones.available.names[0]
  default_for_az    = true
}

resource "aws_instance" "ec2_docker" {  
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = data.aws_key_pair.ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.ec2_docker_sg.id]
  subnet_id              = data.aws_subnet.shared_subnet.id

  user_data = data.cloudinit_config.ec2_config.rendered
  
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
    encrypted             = true
  }

  tags = {
    Name = var.tag
  }
}