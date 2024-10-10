resource "aws_ssm_parameter" "ami" {
  name  = "/${var.project}/${var.env}/ami_info"
  type  = "String"
  value = aws_ami_from_instance.backend.id
}