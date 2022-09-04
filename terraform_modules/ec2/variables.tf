variable "region" {
  description = "AWS Region to create the infrastructure"
  type        = string
  default     = "us-west-2"
}

variable "name" {
  description = "Name of the EC2 instance be created"
  type        = string
}

variable "ami_id" {
  description = "ID of the AMI to be used to create the EC2"
  type        = string
}

variable "vpc_id" {
  description = "Id of the VPC to create the EC2"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Id of the subnet to create the EC2"
  type        = string
  default     = null
}

variable "ports_to_allow_ingress" {
  description = "Ports to allow ingress traffic"
  type        = list(number)
  default     = []
}

variable "ports_to_allow_egress" {
  description = "Ports to allow egress traffic"
  type        = list(number)
  default     = []
}

variable "key_name" {
  description = "Name of the SSH key to use to connect to the EC2 instance"
  type        = string
}
