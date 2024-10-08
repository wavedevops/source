resource "aws_instance" "app" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_groups
  subnet_id              = var.subnet_id

  # Spot Instance Market Options
  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price                      = "0"  # Automatically use the lowest price
      instance_interruption_behavior = "stop"  # Stop instead of terminate on interruption
      spot_instance_type             = "persistent"  # Keep instance running even after interruption
    }
  }

  # Tags for the instance
  tags = {
    Name = var.component
  }
}
