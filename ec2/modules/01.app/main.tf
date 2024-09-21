# AWS EC2 Spot Instance
resource "aws_instance" "app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups
  subnet_id              = ""

  instance_market_options {
    market_type = "spot"
    spot_options {
      max_price                      = "0"                      # Automatically use lowest price
      instance_interruption_behavior = "stop"                   # Stop instead of terminate on interruption
      spot_instance_type             = "persistent"             # Keep instance running even after interruption
    }
  }

  tags = {
    Name = "${var.component}-${var.env}"
  }
}

resource "cloudflare_record" "app" {
  zone_id = data.cloudflare_zone.zone.id
  name    = var.component
  content = var.dns_record
  type    = "A"
  ttl     = 60
  proxied = false
  depends_on = [aws_instance.app]        # Ensure the DNS record waits for the instance to be created

}


