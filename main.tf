terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "network" {
  source = "./modules/network"

  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
}

module "security" {
  source = "./modules/security"

  vpc_id         = module.network.vpc_id
  workstation_ip = var.workstation_ip

  depends_on = [
    module.network
  ]
}

module "bastion" {
  source = "./modules/bastion"

  instance_type = var.bastion_instance_type
  key_name      = var.generated_key_name
  subnet_id     = module.network.public_subnets[0]
  sg_id         = module.security.bastion_sg_id

  depends_on = [
    module.network,
    module.security
  ]
}

module "application" {
  source = "./modules/application"

  instance_type       = var.app_instance_type
  key_name            = var.generated_key_name
  vpc_id              = module.network.vpc_id
  public_subnets      = module.network.public_subnets
  private_subnets     = module.network.private_subnets
  webserver_sg_id     = module.security.application_sg_id
  alb_sg_id           = module.security.alb_sg_id
  efs_dns_name        = module.efs.efs_dnsname
  efs_ip              = module.efs.efs_ip
  database_private_ip = module.database.private_ip

  depends_on = [
    module.network,
    module.security,
    module.database,
    module.efs
  ]
}

module "database" {
  source = "./modules/database"

  instance_type   = var.db_instance_type
  key_name        = var.generated_key_name
  vpc_id          = module.network.vpc_id
  amis            = var.amis[var.aws_region]
  private_subnets = module.network.private_subnets[0]
  database_sg_id  = module.security.database_sg_id
  db_password     = var.db_password

  depends_on = [
    module.network,
    module.security,
    module.bastion
  ]
}

module "efs" {
  source          = "./modules/efs"
  webserver_sg_id = module.security.application_sg_id
  private_subnets = module.network.private_subnets

}

resource "tls_private_key" "deploy_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform_key" {
  key_name   = var.generated_key_name
  public_key = tls_private_key.deploy_key.public_key_openssh

  provisioner "local-exec" { # Generate "terraform-key-pair.pem" in current directory
    command = <<-EOF
      echo '${tls_private_key.deploy_key.private_key_pem}' > ./'${var.generated_key_name}'.pem
      chmod 600 ./'${var.generated_key_name}'.pem
    EOF
  }

}

resource "null_resource" "provisioner_wp_config" {
  provisioner "file" {
    source      = "files/wp-config.php"
    destination = "/tmp/wp-config.php"

    connection {
      type        = "ssh"
      agent       = false
      host        = module.application.private_ips[0]
      user        = "ubuntu"
      private_key = file("terraform-key-pair.pem")

      bastion_host        = module.bastion.public_ip
      bastion_user        = "ubuntu"
      bastion_private_key = file("terraform-key-pair.pem")
    }
  }
  depends_on = [
    module.network,
    module.security,
    module.bastion,
    module.database,
    module.application
  ]
}

resource "null_resource" "move_wp_config" {
  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo cp /tmp/wp-config.php /var/www/html/wp-config.php",
      "sudo sed -i 's/dbname/${var.db_name}/g' /var/www/html/wp-config.php",
      "sudo sed -i 's/dbuser/${var.db_admin}/g' /var/www/html/wp-config.php",
      "sudo sed -i 's/dbpass/${var.db_password}/g' /var/www/html/wp-config.php",
      "sudo sed -i 's/dhhost/${module.database.private_ip}/g' /var/www/html/wp-config.php",
      "sudo chown www-data:www-data /var/www/html/wp-config.php"
    ]
    connection {
      type        = "ssh"
      agent       = false
      host        = module.application.private_ips[0]
      user        = "ubuntu"
      private_key = file("terraform-key-pair.pem")

      bastion_host        = module.bastion.public_ip
      bastion_user        = "ubuntu"
      bastion_private_key = file("terraform-key-pair.pem")
    }
  }
  depends_on = [
    module.network,
    module.security,
    module.bastion,
    module.database,
    module.application
  ]
}

resource "null_resource" "provision_bastion" {
  provisioner "file" {
    source      = "terraform-key-pair.pem"
    destination = "/home/ubuntu/.ssh/deploy"

    connection {
      host        = module.bastion.public_ip
      type        = "ssh"
      user        = "ubuntu"
      agent       = false
      private_key = file("terraform-key-pair.pem")
    }
  }
  depends_on = [
    module.network,
    module.security,
    module.bastion
  ]
}

resource "null_resource" "provision_database" {

  connection {
    type        = "ssh"
    agent       = false
    host        = module.database.private_ip
    user        = "ubuntu"
    private_key = file("terraform-key-pair.pem")

    bastion_host        = module.bastion.public_ip
    bastion_user        = "ubuntu"
    bastion_private_key = file("terraform-key-pair.pem")
  }

  provisioner "file" {
    source      = "files/wordpress.sql"
    destination = "/home/ubuntu/wordpress.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "sudo mysql -u root wordpress < /home/ubuntu/wordpress.sql"
    ]
  }
  depends_on = [
    module.network,
    module.security,
    module.bastion,
    module.database
  ]
}
