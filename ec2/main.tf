module "frontend" {
  source        = "./modules/01.app"
  env           = "test"
  component     = "frontend"
  ami           = data.aws_ami.ami.id
  instance_type = "t2.micro"
  dns_record    = module.frontend.public_ip
  security_groups = [data.aws_security_group.allow_all.id]
#   subnet_id     = data.aws_subnet.default_subnet.id
}
