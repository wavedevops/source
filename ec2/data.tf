data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "RHEL-9-DevOps-Practice"
  owners      = ["973714476881"]
}

data "aws_ssm_parameter" "token" {
  name = "api_token"
}

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

data "aws_subnet" "default_subnet" {
  vpc_id = data.aws_vpc.default.id
  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}