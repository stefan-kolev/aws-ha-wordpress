output "application_sg_id" {
  description = "web server sg id"
  value       = aws_security_group.application.id
}

output "alb_sg_id" {
  description = "alb sg id"
  value       = aws_security_group.alb.id
}

output "database_sg_id" {
  description = "RDS sg id"
  value       = aws_security_group.db.id
}

output "bastion_sg_id" {
  description = "bastion sg id"
  value       = aws_security_group.bastion.id
}
