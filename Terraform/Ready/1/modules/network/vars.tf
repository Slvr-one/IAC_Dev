
variable "gen_tags" {
  description = "general tags; Owner, exp_date, bootcamp"
  type        = map(any)
}

variable "az" {
  description = "availability zone"
}

variable "vpc_cidr" {
  description = "vpc cidr range"
}

variable "nginx_port" {
  type        = number
  description = "port nginx will server to, should be opened in secrurity group and listen for in lb listener & healthcheck"
}

variable "local_ip" {
  description = "ip of local machine to allow access from to instances & elb"
}

variable "vpc_name" {
  type        = string
  description = "name for main vpc"
}

variable "private_sb_count" {
  type        = number
  description = "number of private subnets"
}

variable "public_sb_count" {
  type        = number
  description = "number of public subnets"
}