resource "aws_instance" "this" {
  depends_on = [aws_security_group.this]

  ami                         = var.ami_id
  instance_type               = "t3.micro"
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  security_groups             = [aws_security_group.this.id]
  key_name                    = var.key_name

  tags = {
    Name = var.name
  }
}

resource "aws_security_group" "this" {
  name   = "${var.name}_sg"
  vpc_id = var.vpc_id

  ingress {
    description      = "Allow SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  dynamic "ingress" {
    for_each = var.ports_to_allow_ingress
    iterator = ingress_port

    content {
      from_port        = ingress_port.value
      to_port          = ingress_port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  dynamic "egress" {
    for_each = var.ports_to_allow_egress
    iterator = egress_port

    content {
      from_port        = egress_port.value
      to_port          = egress_port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = {
    Name = "${var.name}-sg"
  }
}
