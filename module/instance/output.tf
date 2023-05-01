// module.instance.OutlineClientAccessKey
output "OutlineClientAccessKey" {
  value = data.external.access_key.result["accessKey"]
}

// module.instance.Region
output "Region" {
  value = var.aws_region
}

// module.instance.SecurityGroupID
output "SecurityGroupID" {
  value = aws_security_group.govpn_security.id
}
