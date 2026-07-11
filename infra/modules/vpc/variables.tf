variable "project_name" {
  description = "Project name"
  type        = string
}
variable "env" {
  type = string
}
variable "tags" {
  type = map(string)
  default = {
  Environment = "prod"
  Project     = "my-app"
  ManagedBy   = "terraform"
  }
}
variable "single_nat_gateway" {
  type = bool
  default = true 
}

variable "vpc_cidr" {
  type = string
  default = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDR list"
  type        = list(string)
}


variable "public_subnets" {
  description = "Public subnet CIDR list"
  type        = list(string)
}
variable "enable_nat_gateway" {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}
