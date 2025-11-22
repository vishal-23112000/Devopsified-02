output "ec2_public_ip" {
  description = "Public IP of the anime web server"
  value       = aws_instance.anime_server.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the anime web server"
  value       = aws_instance.anime_server.public_dns
}
