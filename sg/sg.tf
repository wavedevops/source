resource "aws_security_group" "allow_all" {
  name        = "allow_all"
  description = "Security Group allowing all inbound TCP traffic"

  // Ingress rule allowing all inbound TCP traffic
  ingress {
    description = "Allow all inbound TCP traffic"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // Egress rule allowing all outbound traffic
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_all"
  }
}