# Adding the below block to avoid using the default security groups

resource "aws_security_group" "public_instance_sg" {
  name        = "public-instance-sg"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.my_vpc.id
  # allow all trafic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "public_instance" {
  ami                         = "ami-02bbe13b2401b91f9"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  key_name                    = "connection_key" # Replace with the name of your key pair
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2_instance_profile_public.name
  vpc_security_group_ids      = [aws_security_group.public_instance_sg.id]

  provisioner "file" {
    source      = local_file.tf-key.filename
    destination = "/home/ec2-user/remote_key.pem"
    connection {
      user        = "ec2-user"
      private_key = file(local_file.tf-key.filename)
      host        = self.public_ip
    }
  }
  # Need more configuration here to be able to make a connection from this instance to the private one

  depends_on = [
    local_file.tf-key
  ]
}

# Create a security group
resource "aws_security_group" "private_instance_sg" {
  name        = "private-instance-sg"
  description = "Security group for private instance"
  vpc_id      = aws_vpc.my_vpc.id

  # Ingress rule for SSH (port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allowing SSH access from any IP, adjust as needed
  }

  # Egress rule to allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "private_instance" {
  ami                    = "ami-02bbe13b2401b91f9" # Replace with the desired AMI ID for the private instance
  instance_type          = "t2.micro"              # Replace with the desired instance type
  subnet_id              = aws_subnet.private_subnet.id
  key_name               = "connection_key" # Replace with the name of your key pair
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile_private.name
  vpc_security_group_ids = [aws_security_group.private_instance_sg.id]
  # No need to use the connection if you don't any changes on the instance
  # connection {
  #   type        = "ssh"
  #   user        = "Boutheyna"                                                                 # Replace with the appropriate username based on the AMI
  #   private_key = file("./connection_key") # Replace with the correct path to your private key file
  #   host        = self.private_ip
  # }
  tags = {
    Name = "private-instance"
  }
  user_data = file("install_nginx.sh")

  depends_on = [
    local_file.tf-key
  ]


}



# data "aws_instance" "private_instance" {
#   tags = {
#     Name = "private-instance"
#   }
# }
