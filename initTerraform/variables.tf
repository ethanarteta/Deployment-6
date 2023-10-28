variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
  sensitive   = true 
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
  sensitive   = true 
}

variable "key_name" {
    description = "key_name"
    type = string
    sensitive = true
}