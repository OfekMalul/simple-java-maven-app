# Author: Ofek Malul
# Date: 7/1/2024
# Goal: Create an EC2 to run java application

locals {
  ingress_map = {
    "HTTP" = {
      port        = 80,
      cidr_blocks = ["0.0.0.0/0"]
    }
    "SSH" = {
      port        = 22,
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  egress_map = {
    "Anywhere" = {
      port        = 0,
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

data "aws_vpc" "default" {
    default = true
}

resource "aws_security_group" "app_server_sg" {
  name        = "Java_hello_world"
  description = "enable inbound and outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  dynamic "ingress" {
    for_each = local.ingress_map
    content {
      description = ingress.key
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = local.egress_map
    content {
      description = egress.key
      from_port   = egress.value.port
      to_port     = egress.value.port
      protocol    = -1
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_instance" "app_server" {
  ami           = "ami-0c7217cdde317cfec"
  instance_type = "t2.micro"
  key_name      = "instance_machine"
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids = [aws_security_group.app_server_sg.id]
  user_data              = <<-EOL
    #!/bin/bash
    sudo apt-get update -y
    sudo apt-get install -y  ca-certificates curl gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo docker run ofekmalul/java_hello_world:latest
  EOL
}