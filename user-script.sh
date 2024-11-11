user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt install nginx -y
    echo "<h1> ${var.vpc_name}-Public-Server-${count.index + 1} </h1>" >> /var/www/html/index.html
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo systemctl status nginx
    sudo apt update -y
    # updated the file and waiting for it to get updated.
    # Same with another instance.
EOF