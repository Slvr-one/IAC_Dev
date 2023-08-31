variable "instance_name" {
  type     = string
  nullable = true
}

variable "aws_subnet" {
  type     = string
  nullable = true
}

variable "aws_security_group" {
  type     = string
  nullable = true
}

variable "volume_type" {
  type        = string
  description = "volume_type"
  default     = "gp3"
  nullable    = false
}

variable "volume_size" {
  type        = number
  description = "volume_size"
  default     = 8
  nullable    = false
}