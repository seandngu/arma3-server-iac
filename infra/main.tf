provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "us-east-1"
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["debian-12*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
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
      protocol    = "udp"
      cidr_blocks = "0.0.0.0/0"
      description = "ArmA III Server"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = "${var.server_manager_ip}/32"
      description = "SSH"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = "${var.server_manager_ip}/32"
      description = "arma-server-manager"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = "0.0.0.0/0"
      ipv6_cidr_blocks = "::/0"
      description      = "Internet access"
    },
  ]

  depends_on = [aws_default_vpc.default]
}

module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "${var.server_name}-ec2"
  ami  = data.aws_ami.debian.id

  instance_type = var.instance_type
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
