output "ec2_information" {
  value = {
    public_ip = module.ec2_instance.public_ip
  }
}
