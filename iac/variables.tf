variable "name" {
  description = "Stack Name"
}

variable "environment" {
  description = "Environment Name"
}

variable "aws_access_key" {
  type = string
  description = "AWS access key"
}
variable "aws_secret_key" {
  type = string
  description = "AWS secret key"
}
variable "aws_region" {
  type = string
  description = "AWS region"
}

variable "vpc_cidr" {
  type = string
  description = "VPC CIDR Block"
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  description = "Private Subnets"
  default     = ["10.0.0.0/20", "10.0.32.0/20"]
}

variable "public_subnets" {
  description = "Public Subnets"
  default     = ["10.0.16.0/20", "10.0.48.0/20"]
}

variable "availability_zones" {
  description = "Availablility Zones"
  default     = ["us-east-2a", "us-east-2b"]
}

variable "container_port" {
  description = "Exposed Docker Port"
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  default     = 256
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  default     = 512
}

variable "health_check_path" {
  description = "Http path for task health check"
  default     = "/"
}

variable "environment_variables" {
  description = "Environment Variables"
}

variable "hosted_zone" {
  description = "Hosted zone to create Route53 entries"
}