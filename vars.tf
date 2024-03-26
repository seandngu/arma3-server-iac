variable "server_name" {
  type        = string
  description = "Used for resource/module names"
}

variable "access_key" {
  type        = string
  description = "AWS access key"
}

variable "secret_key" {
  type        = string
  description = "AWS secret key"
}

# Security Group
variable "server_manager_ip" {
  type        = string
  description = "For RDP access"
}

# EC2
variable "key_pair_name" {
  type        = string
  description = "Key for access created manually on AWS console"
}

variable "storage_size" {
  type        = number
  description = "Size for EC2 instance in gb"
}
