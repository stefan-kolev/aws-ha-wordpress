output "private_ip" {
  description = "public ip address"
  value       = aws_instance.db.private_ip
}