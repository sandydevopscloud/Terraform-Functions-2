resource "aws_instance" "Private-Server" {
  # count                  = length(var.private_cidr_block)
  count                  = var.environment == "PRD" ? 1 : 2 # Create 1 private if true, else 2 private instance.
  ami                    = lookup(var.amis, var.region_name)
  instance_type          = var.ec2_inst_type #"t3.micro"
  key_name               = var.key_name      #"sandy-pem"
  subnet_id              = element(aws_subnet.private-subnet.*.id, count.index + 1)
  vpc_security_group_ids = ["${aws_security_group.allow_all.id}"]

  tags = {
    Name        = "Private-SRV-${count.index + 1}"
    environment = "PRD"
    Owner       = "Sandy"
    Costcenter  = ""
  }
  # user_data = <<-EOF
  #       #!/bin/bash
  #       sudo apt update -y
  #       sudo apt install nginx -y
  #       sudo apt install git -y
  #       sudo git clone https://github.com/saikiranpi/SecOps-game.git
  #       sudo rm -rf /var/www/html/index.nginx-debian.html
  #       sudo cp SecOps-game/index.html /var/www/html/index.html
  #       echo "<h1> ${var.vpc_name}-Private-Server-${count.index + 1} </h1>" >> /var/www/html/index.html
  #       sudo systemctl start nginx
  #       sudo systemctl enable nginx
  #   EOF
}
