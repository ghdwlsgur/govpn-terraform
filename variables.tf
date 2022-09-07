

variable "volume_size" {
  type        = string
  description = "12GB"
  default     = "12"
}
variable "aws_profile" {
  description = "AWS CLI profile"
  default     = "default"
}
variable "instance_type" {
  type        = string
  description = "c4.large"
  default     = "c4.large"
}
variable "aws_region" {
  type        = string
  description = "AWS Region - INPUT VALUE"
}
variable "ec2_ami" {
  type        = string
  description = "Ec2's image (Linux 2) - INPUT VALUE"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
