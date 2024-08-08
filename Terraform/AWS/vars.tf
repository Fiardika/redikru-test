variable "AWS_REGION" {
    default = "ap-southeast-1"
}

#Change the value with your key
variable "AWS_ACCESS_KEY" {
    default = "value"
}

#Change the value with your key
variable "AWS_SECRET_KEY" {
    default = "value" 
}

variable "PROJECT" {
    default = "Redikru"
}

variable "AVAILABILITY_ZONE" {
    default = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "VPC_CIDR_INSTANCE" {
    default = "192.168.0.0/16"
}

variable "PUBLIC_SUBNETS_CIDR_INSTANCE" {
    default = ["192.168.1.0/24", "192.168.2.0/24"]
}

variable "INSTANCE_TYPE" {
  default   =  "t3a.micro"
}

variable "KEY" {
    default = "redikru"
}

variable "bucket_name" {
  default   =  "fiardika-redikru-test"
}

variable "PUBLIC_KEY_PATH" {
  description = "Path to the public key file"
  default     = "~/.ssh/id_rsa.pub"
}