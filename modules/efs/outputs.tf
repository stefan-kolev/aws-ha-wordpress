output "efs_dnsname" {
  description = "efs dns name"
  value = aws_efs_file_system.efswordpress.id
}

output "efs_ip" {
  description = "efs ip address"
  value = aws_efs_mount_target.mtwordpress.ip_address
}