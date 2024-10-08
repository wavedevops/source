module "vpn" {
  source          = "./01.ec2"
  ami             = data.aws_ami.vpn.id
  component       = "vpn"
  instance_type   = "t2.micro"
  security_groups = [ data.aws_security_group.allow_all.id ]
  subnet_id       = var.subnets["us-east-1a"]
}

module "dnf" {
  source  = "./02.dns"
  zone_id = data.aws_route53_zone.zone.id
  name    = "vpn"
  type    = "A"
  ttl     = "5"
  records = [module.vpn.public_ip]
}


# output "ami" {
#   value = data.aws_ami.vpn.id
# }
# output "sg_id" {
#   value = [ data.aws_security_group.allow_all.id ]
# }
# output "subnet" {
#   value = var.subnets["us-east-1a"]
# }