# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "my-terraform-learning-vpc"
  }
}

# Create Subnet
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  tags = {
    Name = "my-terraform-learning-subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_IGW" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my-terraform-learning-IGW"
  }
}

# Create Route Table
resource "aws_route_table" "my_routeTable" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IGW.id
  }
  tags = {
    Name = "my-terraform-learning-routeTable"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "my_routeTable_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_routeTable.id
}

# Create Security Group
resource "aws_security_group" "my_security_group" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "my-terraform-learning-security-group"
  }
}
resource "aws_key_pair" "my_key" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa MIIEogIBAAKCAQEAqn4k6A5woK7b/LBQx1w1whJNyvJBrpZEW0d8hadVjyAVczB1uPdz9tnSGWLNi8GYny1wUErTH62U+XA39E7ZBShL1R9YwmrFmfCenc/45N8iaDyyOpnc6uvUcc9AIpQXGJSQ8f/RJMvNPjbGUmnqErnTBdzvT7H+QEf0FNKYMaFSGaaJE4dLg6XVe7khW4i+Ughc8RmqyAzTQUkIIi03kjVN/cCLXRz2srTYlzh+xJU+tA5t3J4nY7bPhdAqhs1HRR9+olkxtTN7qICHzvHDw71ydwXwZeywQWCp5TyVP9r1w30IdGaDxijw1OdMRk9yiebZEwG/eDhh+hvQA9sXJQIDAQABAoIBACq2A0TnKSv34kCBYxsubIE72KU4319/YYyEchuBehuq6/S5dSRrSW/TzaBycg/K5hMqbPKQbCeJcsKybDIV9qQmHik7+x5pZStVbkcWrMGZbKM0YWnw1bk8bzI7u1NuSgLsZQtbDOfs7nPhgPlwcyVRzB2x5XnPm2Q7Ilh9EYeM+yDLHJgnWlsxoPWP37YRm1iISJMD+6Ci3sf830izb4iTmlLCby1gmgjJSJiBEp3S4njH5G/wE1GUFadWDd/iXNUUtUhmU0aY9eciiOrMRhMLLdaw+SR650OmqHI+Xz5sOwVwpVSmm5uAbjwGqjJDoQXgs52MlL6v30VqJqOdfIECgYEA6HGnKDE5qHoFJoo2ncfBtRi7v0sW7ApO8jxKJ2alXdgE4grEWIpElMtxxY7C3fv9ZDYqr46kxYR4+iHG71I7MJU81b9kijLifqiyiJ87LZ8wR/wc6KXyAVOEzDaypdgnHjypW2EUcUUqQKR+5mdAOvhazjwFSr0LJDrzUNE7O1ECgYEAu8VG3Vsdqnt8Qa7KoCzQdo6owEZrTJ/jvzuDTUuQdDgRAQpUxAZ12JqmgK8Ocx1E3WWvJV/lzz6FmlW6AHQHbXwAD8/YX9S0RkCB32tCMH1JAyhRqNSXjJ3eq81uQCme7NzPVE1LhPPBkbbFa5BRvxOIFveKYCkIaXrHIrSyQZUCgYAEdGkntAnO2MfQfUWesH1d4yN1/xJpY6kvq0ggiS8SJVmym1I4AC5gS6Xai2ngpzur9/3Jb4po3qkS4iLV41WPEM0hq5FZtK/yjXkedS7FKQ/b0VEchFGnBNq+ry2tT/8v7SmxvqKNqS2uH3jvIXtxpeDXov7W99iG0TpoihoAgQKBgHCvSYHaBomjJcS9QvixLEGaB4esOwR3B9RhwMCIUp6MbxfyvUAOqHZfCQE9DSzkKcm8FkoVrPKckM04GTHgb/yyZ88VasLIAZAPcmFEGyrCZSix75+kRXar30+3LyzuTWPUd9Aduu6E4muyBfQxXf2PmSI/WBmxRk0W057uVfOpAoGAUdey+dgbQuo1Mmnbx3pI0kWnuGFGpfkfUgaJUf5LONeu+gc4V+GAhM08DI8yocrGzOcRdHTDMVY7AkbqWIx+s/VBzeeMW78xRUWrMD8k5PetFNa+5gUfVLHuskndi7swI4e/cjbLXGXJ1Hjdb4acOwOvYesTz70Bx/uCZR+GxRA= naveen.kumar2@thoughtworks.com"
}

# Create EC2 Instance
resource "aws_instance" "my_terraform_ec2_Instance" {
  ami             = "ami-01376101673c89611"
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.my_subnet.id
  security_groups = [aws_security_group.my_security_group.id]
  key_name        = aws_key_pair.my_key.key_name
  provisioner "remote-exec" {
    inline = [
      "chmod +x build.sh",
      "./build.sh"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("./ssh/id_rsa")
      host        = self.public_ip
    }
  }

  tags = {
    Name = "my-terraform-learning-EC2-Instance"
  }
}

# Output instance public IP
output "instance_public_ip" {
  value = aws_instance.my_terraform_ec2_Instance.public_ip
}