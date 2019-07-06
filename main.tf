provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "tunnel" {
  ami = "ami-07b4f3c02c7f83d59"
  instance_type = "t2.nano"

  /* provisioner "remote-exec" {
    script = "userdata.sh"

  } */

  user_data = <<-EOF
              #!/bin/bash
              # Install inlets to /usr/local/bin/
              curl -sLS https://get.inlets.dev | sudo sh
              token=$(head -c 16 /dev/urandom | shasum | cut -d" " -f1); inlets server --port=8090 --token="$token" &
              EOF
  tags = {
    Name = "inlets-server"
  }
}

resource "aws_security_group" "instance" {
  name = "inlets-server-instance"
  ingress {
    from_port = 8090
    to_port = 8090
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}