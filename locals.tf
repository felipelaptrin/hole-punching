locals {
  ssh_key_name_with_extension = element(
    split("/", var.path_to_ssh_key),
    length(split("/", var.path_to_ssh_key)) - 1
  )
  ssh_key_name = element(
    split(".pem", local.ssh_key_name_with_extension),
    0
  )
}
