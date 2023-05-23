data "aws_availability_zones" "available" {
  state = "available"
}

data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://api.ipify.org?format=json'"]
}

# data "external" "myipaddr" {
#   program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
# } # "curl -4 icanhazip.com"