variable "tag" {
  type = string
  default = "ec2_kind_cluster"
}

variable "instance_type" {
  type = string
  default = "t3.micro"
}

variable "root_volume_size" {
  type = number
  default = 20
}

variable "key_name" {
  type = string
  default = "new_aws"
}