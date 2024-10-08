resource "aws_key_pair" "vpn" {
  key_name   = "openvpn"
  public_key = file("~/.ssh/openvpn.pub")

  lifecycle {
    ignore_changes = [key_name]
  }
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

│ Error: importing EC2 Key Pair (openvpn): operation error EC2: ImportKeyPair, https response error StatusCode: 400, RequestID: f945fed9-3b21-4eab-9129-8ca77815e142, api error InvalidKeyPair.Duplicate: The keypair already exists
│
│   with aws_key_pair.vpn,
│   on vpn.tf line 1, in resource "aws_key_pair" "vpn":
│    1: resource "aws_key_pair" "vpn" {
}

add over ride