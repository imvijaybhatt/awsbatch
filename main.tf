locals {
  subnets_tags = {
    Name      = "tf-workshop-sn-1a"
    Funcation = "Workshop"
  }

  sg_tags = {
    Name      = "tf-workshop-sg"
    Funcation = "Workshop"
  }

  ec2_tags = {
    Name      = "tf-workshop-ec2"
    Funcation = "Workshop"
  }
}

module "subnet" {
  source            = "./modules/subnet"
  vpc_id            = data.aws_vpc.default_vpc.id
  cidr_block        = var.cidr_block
  tags              = local.subnets_tags
  availability_zone = var.availability_zone
  route_table_id    = data.aws_route_table.route_table.id
}

resource "aws_security_group" "main" {
  name        = "tf-workshop-sg"
  vpc_id      = data.aws_vpc.default_vpc.id
  description = "Allow SSH access"
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["103.240.204.68/32"]


  }
  tags = local.sg_tags
}

resource "aws_instance" "main" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  key_name                    = var.key_name
  subnet_id                   = module.subnet.id
  vpc_security_group_ids      = [aws_security_group.internal.id]
  tags                        = local.ec2_tags

  #USERDATA in AWS EC2 using Terraform
  user_data = <<-EOF
#!/bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache

  EOF
}

resource "aws_eip" "lb" {
  instance = aws_instance.main.id
  vpc      = true
}


resource "aws_volume_attachment" "volume2" {
  device_name = "/dev/xvdg"
  volume_id   = aws_ebs_volume.volume2.id
  instance_id = aws_instance.main.id
}



resource "aws_ebs_volume" "volume2" {
  availability_zone = var.availability_zone
  size              = 8
  type = "gp3"
}
resource "aws_security_group" "internal" {
  name        = "internal_sg"
  description = "Internal security group"
  vpc_id      = data.aws_vpc.default_vpc.id
  ingress {
    to_port     = 80
    from_port   = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip}/32"]
  }
  ingress {
    to_port     = 22
    from_port   = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.allowed_ip}/32"]
  }
 
  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
}
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  
}

}
