output "private_ip" {
  value = aws_instance.app.private_ip
}

output "public_ip" {
  value = aws_instance.app.public_ip
}