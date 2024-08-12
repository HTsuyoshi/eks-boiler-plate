resource "aws_key_pair" "bastion_public_key" {
  key_name   = "bastion_eks"
  public_key = file(var.bastion_config.public_key_path)

  tags = {
    Name = "Bastion AWS Key Pair - ${var.project_name}",
    Type = var.module_name
  }
}

resource "aws_instance" "bastion" {
  instance_type          = var.bastion_config.instance_type
  ami                    = var.image_ami_id
  key_name               = aws_key_pair.bastion_public_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]
  subnet_id              = var.public_subnet_id
  iam_instance_profile   = aws_iam_instance_profile.bastion_profile.name
  private_ip             = var.bastion_config.private_ip

  depends_on = [
    aws_iam_role_policy_attachment.bastion_policy_attachment
  ]

  root_block_device {
    volume_type = var.bastion_config.volume_type
    volume_size = var.bastion_config.volume_size
  }

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSHd is ready'"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.bastion_config.private_key_path)
      host        = aws_instance.bastion.public_ip
    }
  }

  tags = {
    Name = "Bastion EC2 - ${var.project_name}",
    Type = var.module_name
  }
}
