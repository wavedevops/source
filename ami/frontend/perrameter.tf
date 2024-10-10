resource "aws_ssm_parameter" "ami" {
  name  = "/${var.project}/${var.env}/${var.component}"
  type  = "String"
  value = aws_ami_from_instance.frontend.id
}