# # Retrieve the password from AWS Systems Manager Parameter Store
# data "aws_ssm_parameter" "hari_password" {
#   name            = "iam"  # Replace with your actual parameter name
# #   with_decryption = false # Decrypts the SecureString value
# }