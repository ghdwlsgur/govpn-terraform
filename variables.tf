variable "instance_type" {
  type        = string
  description = "t2.micro"
  default     = "t2.micro"
}

variable "aws_region" {
  type        = string
  description = "Canada"
  default     = "ca-central-1"
}

variable "volume_size" {
  type        = string
  description = "12GB"
  default     = "12"
}

variable "aws_profile" {
  description = "AWS CLI profile"
  default     = "default"
}

variable "ec2_amis" {
  type        = map(string)
  description = "Ec2's image (Linux 2)"
  default = {
    ca-central-1   = "ami-00f881f027a6d74a0"
    us-east-2      = "ami-02d1e544b84bf7502"
    us-east-1      = "ami-0cff7528ff583bf9a"
    us-west-1      = "ami-0d9858aa3c6322f73"
    us-west-2      = "ami-098e42ae54c764c35"
    ap-south-1     = "ami-08df646e18b182346"
    ap-northeast-3 = "ami-0c66c8e259df7ec04"
    ap-northeast-2 = "ami-0fd0765afb77bcca7"
    ap-northeast-1 = "ami-0b7546e839d7ace12"
    ap-southeast-1 = "ami-0c802847a7dd848c0"
    ap-southeast-2 = "ami-07620139298af599e"
    sa-east-1      = "ami-037c192f0fa52a358"
  }
}



