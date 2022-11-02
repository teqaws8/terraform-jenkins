terraform {

  required_providers {
    aws = {
    source  = "hashicorp/aws"

    version = "~> 3.27"

    }
  }


  required_version = ">= 0.14.9"

}

provider "aws" {

  region                = var.aws_region
  shared_credentials_file = "/root/.aws/credentials"
  profile               = "profile1"

}

resource "aws_instance" "webserver" {

  ami = "ami-02ea247e531eb3ce6"
  instance_type = var.instance_type
  key_name = "transit-gw"
 vpc_security_group_ids = [aws_security_group.web-sg.id]
associate_public_ip_address = true
  root_block_device {
    volume_type = "gp2"
    volume_size = "8"
    delete_on_termination = false

}

 

  user_data = <<EOF

#!/bin/bash

sudo apt-get update -y

#sudo apt-get upgrade -y

sudo apt-get install apache2 -y

sudo systemctl restart apache2

sudo chmod 777 -R /var/www/html/

cd /var/www/html/

sudo echo "<h1>This is our test website deployed using Terraform.</h1>" > index.html

EOF

  tags = {
    Name = "ExampleEC2Instance"
  }
}

output "IPAddress" {
  value = "${aws_instance.webserver.public_ip}"
}
