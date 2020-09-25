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

resource "aws_instance" "myawsserver" {
  ami = "ami-0b16724fe8e66e4ec"
  key_name = "Tanmoy"
  instance_type = "t2.micro"

  tags = {
    Name = "Tanmoy-Ubuntu-Server"
    Env = "Dev"
  }
  provisioner "local-exec" {
    command = "echo The servers IP address is ${self.public_ip} && echo ${self.private_ip} myawsserver >> /etc/hosts"
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
