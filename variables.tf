variable "region" {
  default = "us-east-1"  # Replace with your desired AWS region
}

variable "key_name" {
  description = "Name of the EC2 key pair"
  default     = "mykey-pair"  # Replace with your actual key pair name
}

variable "PUBLIC_KEY_PATH" {}
