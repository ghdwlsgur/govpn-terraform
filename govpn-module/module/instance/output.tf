

output "OutlineClientAccessKey" {
  value = data.external.access_key.result["accessKey"]
}

output "Region" {
  value = var.aws_region
}
