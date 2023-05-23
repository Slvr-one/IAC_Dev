output "elb-dns-name" {
  value = aws_elb.ubuntu_lb.*.dns_name
}