output "ec2_information" {
  value = {
    public_ip   = data.aws_instance.default.public_ip
    domain_name = data.aws_instance.default.public_dns
    key_name = data.aws_instance.default.key_name
  }

  depends_on = [ resource.aws_ec2_instance_state.default ]
}
