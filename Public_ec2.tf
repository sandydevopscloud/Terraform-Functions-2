resource "aws_instance" "Public-Server" {
  #   count                       = length(var.public_cidr_block)
  count                       = var.environment == "PRD" ? 3 : 1 # Create 3 public if true, else 1 public instance.
  ami                         = lookup(var.amis, var.region_name)
  instance_type               = var.ec2_inst_type #"t3.micro"
  key_name                    = var.key_name      #"sandy-pem"
  subnet_id                   = element(aws_subnet.public-subnet.*.id, count.index + 1)
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = "true"

  tags = {
    Name        = "Public-SRV-${count.index + 1}"
    environment = "PRD"
    Owner       = "Sandy"
    Costcenter  = ""
  }
  user_data = <<-EOF
        #!/bin/bash
        sudo apt update -y
        sudo apt install nginx -y
        echo "<h1> ${var.vpc_name}-Public-Server-${count.index + 1} </h1>" >> /var/www/html/index.html
        sudo systemctl start nginx
        sudo systemctl enable nginx
    EOF
}
