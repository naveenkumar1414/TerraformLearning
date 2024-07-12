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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDWEkhPcokWN9mIA76PqXImND6Go8yKshn6DZbCVoRt6QFAShbYTse85v0sS//NXseRRaxH56njXJ+jEwf+SFzLEgLAl/AcAzAM4HGFkoyIvBEHOFJ8MpKm4M0Siut/nZVFHvyy7BrZq3GdjjKKuCAF/K7ynLngAZFnThbXU0bQ4PFKg3c9TjcVZRAaYb5oImkHGhvEfZSYrxjODqzAQCTpe1W7w6QsT4VrizxCFRuDgZOOdlpDuywDdqF9D+38HvCeWSoaRCKNovtFkKKezoyWQIO8sdjnkafysWlgfwCNoSdZCsorSOnykKwTW1QXzs3VdhctSZz+fEspB/3/CzhsLiApwyOrPttt91GjmsjtU4TuTcPvT0s+EwUKEihYFPrN6Y1rH0UAEUAHWCAlKNm9NsHHxWTfiVawzO/Bl77NwAQk2im275sQjnjWDYYtG2m0sFqDvsXMPAN2mYjzjCLdLYcRP+9KB2/cnxaY74ybaTuJr6qZZpaI314pJpQh1gVeaki4EnQ4xRXyGmNeslqg56GQoftTctKi8w3rcEH0WbRy0n3TtmwF3yeg10MO7cMP0leimQIRZPvK09BCUeeJ/DEnPypCukn4k+AoKujDjIjOczUHIFUcVGTIL+fdeLygiPS+2804W5Fe+OCRrfEZdWZ+VT8gDm1kqvbA7QlnhQ== naveen.kumar2@thoughtworks.com"
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
      "./build.sh",
      "chmod +x ./ssh/id_rsa"
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