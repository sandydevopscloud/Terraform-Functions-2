resource "null_resource" "user_cluster" {
  count = var.environment == "PRD" ? 3 : 1
  provisioner "file" {
    source      = "user-script.sh"
    destination = "/tmp/user-script.sh"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("sandy-pem.pem")
      host        = element(aws_instance.Public-Server.*.public_ip, count.index + 1)
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod 700 /tmp/user-script.sh",
      "sudo /tmp/user-script.sh",
      "sudo apt update -y",
      "sudo apt install jq unzip -y",
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("sandy-pem.pem")
      host        = element(aws_instance.Public-Server.*.public_ip, count.index + 1)
    }
  }
}

