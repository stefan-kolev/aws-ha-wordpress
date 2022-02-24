output "alb_url" {
  description = "URL of wordpress"
  value       = "http://${module.application.dns_name}/"
}

output "bastion_public_ip" {
  description = "bastion public ip"
  value       = module.bastion.public_ip
}