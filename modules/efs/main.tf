resource "aws_efs_file_system" "efswordpress" {
  creation_token = "EFS for WordPress"

  tags = {
    Name = "EFS for WordPress"
  }
}

resource "aws_efs_mount_target" "mtwordpress" {
  file_system_id  = aws_efs_file_system.efswordpress.id
  subnet_id       = var.private_subnets[0]
  security_groups = [var.webserver_sg_id]
}