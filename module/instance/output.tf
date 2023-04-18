

output "OutlineClientAccessKey" {
  value = data.external.access_key.result["accessKey"]
}

output "Region" {
  value = var.aws_region
}

output "SecurityGroupID" {
  value = aws_security_group.govpn_security.id
}
