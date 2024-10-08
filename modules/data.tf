data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "RHEL-9-DevOps-Practice"
  owners      = ["973714476881"]
}

data "aws_ami" "vpn" {
  most_recent = true
  owners = ["679593333241"]
  filter {
    name = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db-*"]
  }
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

data "aws_route53_zone" "zone" {
  name         = "chowdary.cloud"
  private_zone = false
}
