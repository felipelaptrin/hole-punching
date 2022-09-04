data "template_file" "ansible_config" {
  depends_on = [
    module.host_with_strict_firewall,
    module.third_party_server
  ]

  template = file("${path.module}/template_ansible_inventory.tpl")
  vars = {
    host_ip      = module.host_with_strict_firewall.public_ip
    server_ip    = module.third_party_server.public_ip
    ssh_key_path = var.path_to_ssh_key
  }
}
