# if you create the pem key using Terraform you should always keep its configuration in terraform

resource "aws_key_pair" "key-pair" {
  key_name   = "connection_key"
  public_key = tls_private_key.rsa.public_key_openssh

}


resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


resource "local_file" "tf-key" {
  content         = tls_private_key.rsa.private_key_pem
  filename        = "connection_key.pem"
  file_permission = "400"
}