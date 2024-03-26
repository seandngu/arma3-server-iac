provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}

resource "aws_default_vpc" "default" {
}

module "security_group" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "${var.server_name}-sg"
  description = "Security group for with rules allowing RDP from selected client, TeamSpeak, and ArmA III ports"
  vpc_id      = aws_default_vpc.default.id

  ingress_with_cidr_blocks = [
    {
      from_port   = 9987
      to_port     = 9987
      protocol    = "udp"
      cidr_blocks = "0.0.0.0/0"
      description = "TeamSpeak Voice"
    },
    {
      from_port   = 30033
      to_port     = 30033
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "TeamSpeak File Transfer"
    },
    {
      from_port   = 2302
      to_port     = 2306
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
      description = "ArmA III Server"
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      cidr_blocks = "${var.server_manager_ip}/32"
      description = "RDP TCP"
    },
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "udp"
      cidr_blocks = "${var.server_manager_ip}/32"
      description = "RDP UDP"
    },
  ]

  depends_on = [aws_default_vpc.default]
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.server_name}-ec2"
  ami  = "ami-03cd80cfebcbb4481"

  instance_type = "c6a.xlarge"
  root_block_device = [
    {
      volume_type = "gp2"
      volume_size = var.storage_size
    }
  ]
  key_name               = var.key_pair_name
  monitoring             = true
  vpc_security_group_ids = ["${module.security_group.security_group_id}"]

  depends_on = [module.security_group]
}
