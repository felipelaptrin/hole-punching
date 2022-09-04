variable "region" {
  description = "AWS Region to create the infrastructure"
  type        = string
  default     = "us-west-2"
}

variable "name" {
  description = "Name of the EC2 to be created"
  type        = string
}

variable "cidr" {
  description = "CIDR of the VPC to be created"
  type        = string
}
