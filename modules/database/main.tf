data "template_file" "client" {
  template = file("files/db.sh")
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    echo 'db_password="${var.db_password}"' > /tmp/dbpass
    EOF
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }
}

resource "aws_instance" "db" {
  ami                         = var.amis
  instance_type               = var.instance_type
  key_name                    = var.key_name
  vpc_security_group_ids      = [var.database_sg_id]
  subnet_id                   = var.private_subnets
  
  user_data = base64encode(data.template_cloudinit_config.config.rendered)

  tags = {
    Name = "MySQL"
  }
}