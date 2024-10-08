resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  public_key = file("~/.ssh/openvpn.pub")
}


resource "aws_instance" "vpn" {
  key_name = aws_key_pair.vpn.key_name
  ami                    = data.aws_ami.vpn.id
  instance_type         = "t3.micro"
  subnet_id             = var.subnets["us-east-1c"]
  vpc_security_group_ids = [data.aws_security_group.allow_all.id]

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price                      = "0"  # Automatically use the lowest price
      instance_interruption_behavior = "stop"  # Stop instead of terminate on interruption
      spot_instance_type             = "persistent"  # Keep instance running even after interruption
    }
  }

  tags = {
    Name = "vpn"
  }
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.zone.id
  name    = "vpn"
  type    = "A"
  ttl     = "5"
  records = [aws_instance.vpn.public_ip]  # Use public_ip instead of id
}