[hosts:children]
server
host

[server]
${server_ip}

[host]
${host_ip}

[hosts:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=${ssh_key_path}