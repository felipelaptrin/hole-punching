module "vpc" {
  count = 2

  source = "./terraform_modules/vpc"
  name   = "vpc-host-${count.index}"
  cidr   = "10.0.${count.index}.0/24"
}

# Host only allow outbound traffic through port 80 and 443
module "host_with_strict_firewall" {
  source                = "./terraform_modules/ec2"
  name                  = "host-with-strict-firewall"
  ami_id                = "ami-0d70546e43a941d70"
  ports_to_allow_egress = [80, 443]
  key_name              = local.ssh_key_name
  vpc_id                = module.vpc[0].vpc_id
  subnet_id             = module.vpc[0].subnet_id
}

module "third_party_server" {
  source                 = "./terraform_modules/ec2"
  name                   = "third-party-server"
  ami_id                 = "ami-0d70546e43a941d70"
  ports_to_allow_egress  = [80, 443]
  ports_to_allow_ingress = [80, 443, 7000]
  key_name               = local.ssh_key_name
  vpc_id                 = module.vpc[1].vpc_id
  subnet_id              = module.vpc[1].subnet_id
}

resource "null_resource" "copy_rendered_template_to_ansible_folder" {
  triggers = {
    template_rendered = data.template_file.ansible_config.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.ansible_config.rendered}' > ansible/inventory"
  }
}

resource "null_resource" "destroy_rendered_template_from_ansible_folder" {
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ansible/inventory"
  }
}
