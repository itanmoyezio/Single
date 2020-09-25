terraform {
  backend "s3" {
    bucket  = "tanmoytfstate"
    key  = "terraform/state"
    region = "us-east-2"
#   access_key = "XXXXXXXXXXXXXXXXXXXXXX"
#   secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "example" {
  most_recent      = true
  owners           = ["self"]
  filter {
    name   = "name"
    values = ["Tanmoy-ubuntu-*"]
  }
}

resource "aws_instance" "myawsserver" {
  ami = "data.aws_ami.example.id"
  key_name = "tanmoy2"
  instance_type = "t2.micro"

  tags = {
    Name = "Tanmoy-Ubuntu-Server"
    Env = "Prod"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > /etc/ansible/hosts"
  }
 
provisioner "remote-exec" {
    inline = [
     "touch /tmp/tanmoyjen"
     ]
 connection {
    type     = "ssh"
    user     = "ubuntu"
    insecure = "true"
    private_key = "${file("/tmp/tanmoy2.pem")}"
    host     =  aws_instance.myawsserver.public_ip
  }
}
}

output "myawsserver-ip" {
  value = "${aws_instance.myawsserver.public_ip}"
}
