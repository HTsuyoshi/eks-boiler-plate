resource "aws_security_group" "bastion_sg" {
  name        = "bastion_sg"
  description = "security group"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_config.source_cidr]
    description = "Allow developer connection to bastion instance"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow outbound connection to all CIDRs"
  }

  tags = {
    Name = "Bastion Security Group - ${var.project_name}",
    Type = var.module_name
  }
}
