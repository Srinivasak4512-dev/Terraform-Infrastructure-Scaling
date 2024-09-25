# main.tf
resource "aws_vpc" "Terraform_scale_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Terraform_scale_vpc"
  }
}

resource "aws_subnet" "Terraform_scale_public_subnet" {
  vpc_id     = aws_vpc.Terraform_scale_vpc.id
  cidr_block = var.public_subnet_cidr_block

  tags = {
    Name = "Terraform_scale_public_subnet"
  }
}

resource "aws_subnet" "Terraform_scale_private_subnet" {
  vpc_id     = aws_vpc.Terraform_scale_vpc.id
  cidr_block = var.private_subnet_cidr_block

  tags = {
    Name = "Terraform_scale_private_subnet"
  }
}

resource "aws_internet_gateway" "Terraform_scale_igw" {
  vpc_id = aws_vpc.Terraform_scale_vpc.id

  tags = {
    Name = "Terraform_scale_igw"
  }
}

resource "aws_route_table" "Terraform_scale_routetable" {
  vpc_id = aws_vpc.Terraform_scale_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Terraform_scale_igw.id
  }

  tags = {
    Name = "Terraform_scale_routetable"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.Terraform_scale_public_subnet.id
  route_table_id = aws_route_table.Terraform_scale_routetable.id
}

resource "aws_security_group" "Terraform_scale_sg" {
  name_prefix = "Terraform_scale_sg"
  vpc_id      = aws_vpc.Terraform_scale_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_launch_configuration" "web_server_lc" {
  name_prefix                 = "web-server-lc"
  image_id                    = var.ami_id
  instance_type               = "t2.micro"
  security_groups             = [aws_security_group.Terraform_scale_sg.id]
  associate_public_ip_address = true

  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install -y apache2
                sudo systemctl start apache2
                sudo systemctl enable apache2
                echo "<html><body><h1>Welcome to my DevSecOps Community!</h1></body></html>" > /var/www/html/index.html
                sudo systemctl restart apache2
                EOF
}

resource "aws_autoscaling_group" "web_server_asg" {
  launch_configuration = aws_launch_configuration.web_server_lc.id
  min_size             = 1
  max_size             = 3
  desired_capacity     = 3
  health_check_type    = "EC2"
  vpc_zone_identifier  = [aws_subnet.Terraform_scale_public_subnet.id]
  force_delete         = true

  tag {
    key                 = "Name"
    value               = "web-server-asg"
    propagate_at_launch = true
  }
}
