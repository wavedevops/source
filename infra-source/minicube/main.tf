variable "subnets" {
  default = {
    us-east-1b = "subnet-084d096cd8e354551",
    us-east-1d = "subnet-00e05b15c4116939b",
    us-east-1a = "subnet-0d6f188df6ab4cfee",
    us-east-1c = "subnet-0969c012e3344c524",
    us-east-1e = "subnet-020eec5c0a3cff8ca",
    us-east-1f = "subnet-05821032acb47d88c"
  }
}

data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "RHEL-9-DevOps-Practice"
  owners      = ["973714476881"]
}

# Get the default VPC
data "aws_vpc" "default" {
  default = true
}

data "aws_security_group" "allow_all" {
  filter {
    name   = "group-name"
    values = ["allow_all"]
  }
  vpc_id = data.aws_vpc.default.id
}





resource "aws_key_pair" "allow_all" {
  key_name   = "vpn"
  public_key = file("~/.ssh/allow_all.pub")
}

module "vpn" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  key_name = aws_key_pair.allow_all.key_name
  name     = "minicube"

  instance_type          = "t3.micro"
  vpc_security_group_ids = [data.aws_security_group.allow_all.id]
  subnet_id              = var.subnets["us-east-1c"]
  ami                    = data.aws_ami.ami.id
  
  tags = {
    Name = "minicube"
  }

  # Spot Instance Configuration
  spot_price = "0"  # Automatically use the lowest price
  spot_options {
    max_price                      = "0"  # Automatically use the lowest price
    instance_interruption_behavior = "stop"  # Stop instead of terminate on interruption
    spot_instance_type             = "persistent"  # Keep instance running even after interruption
  }
}
