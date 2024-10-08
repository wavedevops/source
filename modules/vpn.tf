# resource "aws_instance" "bastion" {
#   ami           = data.aws_ami.vpn.id
#   instance_type = "t2.micro"
#   subnet_id = var.subnets["us-east-1c"]
#   vpc_security_group_ids = [ data.aws_security_group.allow_all.id ]
#   tags =
#     {
#       Name = "vpn"
#     }
# }
#
# resource "aws_route53_record" "record" {
#   zone_id = data.aws_route53_zone.zone.id
#   name    = "vpn"
#   type    = "A"
#   ttl     = "5"
#   records = [module.vpn.public_ip]
# }
#
