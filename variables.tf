variable "availability_zone" {
  description = "availability_zone name."
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for subnet"
  type        = string
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
}

variable "ami_id" {
  description = "AMI to use for the instance."
  type        = string
}
variable "allowed_ip" {
  description = "Allowed IP address"
  type        = string
}