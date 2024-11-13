provider "aws" {
  region = "us-east-1"
}

# Terraform Backend Configuration (S3 for State Storage)
terraform {
  backend "s3" {
    bucket = "chowdary-hari"                 # S3 bucket name for storing Terraform state
    key    = "infra-source/minicube"      # State file path inside the S3 bucket
    region = "us-east-1"                     # AWS region where the S3 bucket is located
  }
}


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


# Minicube instance using spot pricing
resource "aws_instance" "minicube" {
  key_name = aws_key_pair.allow_all.key_name
  ami = data.aws_ami.ami.id
  instance_type = "t3.micro"
  subnet_id = var.subnets["us-east-1c"]
  vpc_security_group_ids = [data.aws_security_group.allow_all.id]

  instance_market_options {
    market_type = "spot"

    spot_options {
      max_price                      = "0"  # Set to the lowest price or remove it for auto selection
      instance_interruption_behavior = "stop"  # Stop instead of terminate on interruption
      spot_instance_type             = "persistent"  # Keep instance running even after interruption
    }
  }

  tags = {
    Name = "minicube"
  }
}
