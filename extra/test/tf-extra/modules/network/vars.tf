variable "cidr_block" {
  description = "list of cidr blocks for subnets of main vpc"
  type        = list(string)
}

variable "tags" {
  description = "general tags"
  type        = map(any)
}

variable "env" {
  description = "workspace, branch, environment"
  type        = string
}

variable "rules" {
  description = "list of -rule- objects for main sg"
  type        = list(any)
  default = [{
    protocol = "tcp"
    port     = 22
    cidr     = ["0.0.0.0/0"]
    desc     = "SSH"
    },
    {
      protocol = "tcp"
      port     = 80
      cidr     = ["0.0.0.0/0"]
      desc     = "HTTP"
    },
    {
      protocol = "tcp"
      port     = 443
      cidr     = ["0.0.0.0/0"]
      desc     = "HTTPS"
    },
    {
      protocol = "tcp"
      port     = 9191
      cidr     = ["0.0.0.0/0"]
      desc     = "costum"
  }]
}