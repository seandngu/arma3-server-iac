output "ec2_information" {
  value = {
    public_ip   = module.ec2_instance.public_ip
    domain_name = module.ec2_instance.public_dns
    key_name    = module.ec2_instance.key_name
  }
}
