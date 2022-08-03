

output "ssh_private_key" {
  value     = tls_private_key.tls.private_key_pem
  sensitive = true
}

output "ssh_ec2_linux_connect" {
  value = "ssh -v -i ~/.ssh/vpn_ec2_key.pem -o IdentitiesOnly=yes ec2-user@${aws_instance.linux.public_ip}"
}

output "changed_ipv4_history" {
  value = "${data.http.myip.body} -> ${aws_instance.linux.public_ip}"
}

output "sg_id" {
  value = aws_security_group.vpn_security.id
}
