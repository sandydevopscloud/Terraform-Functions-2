vpc_cidr_block     = "172.18.0.0/16"
vpc_name           = "vpc-devops"
environment        = "Prod"
key_name           = "sandy-pem"
ec2_inst_type      = "t2.micro"
azs                = ["eu-west-2a", "eu-west-2b", "eu-west-2c"]
public_cidr_block  = ["172.18.1.0/24", "172.18.2.0/24", "172.18.3.0/24"]
private_cidr_block = ["172.18.10.0/24", "172.18.20.0/24", "172.18.30.0/24"]
ingress_value      = ["80", "443", "22", "3306", "1443", "8443", "1900"]
region_name        = "eu-west-2"
amis = {
  eu-north-1 = "ami-08eb150f611ca277f"
  eu-west-2  = "ami-0e8d228ad90af673b"
}
