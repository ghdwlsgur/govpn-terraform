output "ssh_private_key" {
  value     = tls_private_key.tls.private_key_pem
  sensitive = true
}

output "access_key" {
  value = module.instance.OutlineClientAccessKey
}
