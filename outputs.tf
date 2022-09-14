
output "ssh_private_key" {
  value     = tls_private_key.tls.private_key_pem
  sensitive = true
}

output "OutlineClientAccessKey" {
  value = data.external.access_key.result["accessKey"]
}

output "public_dns" {
  value = aws_instance.linux.public_dns
}
