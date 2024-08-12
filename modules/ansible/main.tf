resource "null_resource" "setup_ansible" {
  provisioner "local-exec" {
    working_dir = "./ansible"
    interpreter = ["bash", "-c"]
    command     = <<-EOF
      ansible-playbook -i ${var.bastion_public_ip}, \
        --key-file ${var.bastion_private_key_path} \
        -e 'vpc_id=${var.vpc_id}' \
        -e 'region=${var.region}' \
        -e 'cluster_name=${var.eks_name}' \
        -e 'cluster_endpoint=${var.eks_endpoint}' \
        -e 'karpenter_role_arn=${var.karpenter_federated_role_arn}' \
        -e 'karpenter_instance_profile_name=${var.karpenter_instance_profile_name}' \
        playbook.yaml
      EOF

    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  triggers = {
    file_playbook       = md5(file("./ansible/playbook.yaml"))
    file_dependencies   = md5(file("./ansible/tasks/01_dependencies.yaml"))
    file_eks            = md5(file("./ansible/tasks/02_eks.yaml"))
    file_karpenter      = md5(file("./ansible/tasks/karpenter.yaml"))
    file_metrics_server = md5(file("./ansible/tasks/metrics_server.yaml"))
  }
}