variable "volume_size" {
  type        = string
  description = "12GB"
  default     = "12"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile"
  default     = "default"
}

variable "availability_zone" {
  type        = string
  description = "EC2's Availability Zone - INPUT VALUE"
}

variable "instance_type" {
  type        = string
  description = "EC2's instance type - INPUT VALUE"
}

variable "aws_region" {
  type        = string
  description = "AWS Region - INPUT VALUE"
}

variable "ec2_ami" {
  type        = string
  description = "EC2's image (Linux 2) - INPUT VALUE"
}

variable "key_name" {}
variable "private_key_openssh" {}
variable "private_key_pem" {}

data "http" "myip" {
  url    = "http://ipv4.icanhazip.com"
  method = "GET"
}




