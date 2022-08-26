locals {
  cyberops_vpn_ip = "34.87.70.149/32"
  vpc_cidr = "172.31.0.0/16"
}

resource "aws_instance" "devsecops_pipeline_ci" {
  ami                         = "ami-055d15d9cfddf7bd3"
  instance_type               = "t3a.small"
  key_name                    = "cyberops-devsecops-pipeline"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.devsecops_pipeline_sg.id}"]
  subnet_id                   = "subnet-0269f44b"
  tags = {
    Name        = "devsecops_pipeline_ci"
    Description = "Managed by terraform"
    Owner       = "CyberOps DevSecOps"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to security group, it will force a new resource
      tags, security_groups, vpc_security_group_ids, associate_public_ip_address
    ]
  }
  root_block_device {
    volume_size = "10"
    volume_type = "gp2"
  }
}

resource "aws_instance" "devsecops_pipeline_cd" {
  ami                         = "ami-055d15d9cfddf7bd3"
  instance_type               = "t3a.medium"
  key_name                    = "cyberops-devsecops-pipeline"
  associate_public_ip_address = true
  security_groups             = ["${aws_security_group.devsecops_pipeline_sg.id}"]
  subnet_id                   = "subnet-0269f44b"
  tags = {
    Name        = "devsecops_pipeline_cd"
    Description = "Managed by terraform"
    Owner       = "CyberOps DevSecOps"
  }
  lifecycle {
    ignore_changes = [
      # Ignore changes to security group, it will force a new resource
      tags, security_groups, vpc_security_group_ids, associate_public_ip_address
    ]
  }
  root_block_device {
    volume_size = "40"
    volume_type = "gp2"
  }
}

resource "aws_security_group" "devsecops_pipeline_sg" {
  name        = "devsecops_pipeline_sg"
  description = "Allow access to DevSecOps Pipeline instance from CyberOps VPN"
  vpc_id      = "vpc-fffe2798"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${local.cyberops_vpn_ip}","${local.vpc_cidr}"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["${local.cyberops_vpn_ip}","${local.vpc_cidr}"]
  }

  ingress {
    from_port   = 9000
    to_port     = 9000
    protocol    = "tcp"
    cidr_blocks = ["${local.cyberops_vpn_ip}","${local.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Description = "Managed by terraform"
    Owner       = "CyberOps DevSecOps"
  }
}

# module "devsecops_apps" {
#   source                      = "./modules/ec2"
#   name                        = "devsecops_apps"
#   ami_id                      = "ami-055d15d9cfddf7bd3"
#   instance_type               = "t3a.micro"
#   key_name                    = "cyberops-devsecops-pipeline"
#   associate_public_ip_address = true
#   security_groups             = ["${aws_security_group.devsecops_apps_sg.id}"]
#   subnet_id                   = "subnet-0269f44b"
# }

# resource "aws_security_group" "devsecops_apps_sg" {
#   name        = "devsecops_apps_sg"
#   description = "Allow access to DevSecOps Apps instance from CyberOps VPN"
#   vpc_id      = "vpc-fffe2798"

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["${local.cyberops_vpn_ip}"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["${local.cyberops_vpn_ip}"]
#   }

#   ingress {
#     from_port   = 443
#     to_port     = 443
#     protocol    = "tcp"
#     cidr_blocks = ["${local.cyberops_vpn_ip}"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Description = "Managed by terraform"
#     Owner       = "CyberOps DevSecOps"
#   }
# }