variable "server_port" {
  default = "8080"
}


resource "aws_instance" "example" {
  ami                    = "ami-0d5d9d301c853a04a"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  key_name = "${aws_key_pair.yordanskey.id}"
#Using the ubuntu user and private key to connect to server after deployment
  connection {
    host= "${aws_instance.example.public_dns}"
    user = "ubuntu"
    private_key = "${file("~/.ssh/id_rsa")}"
  }
#adding script to a file and sending the file into the server
  provisioner "file" {
    source = "assets"
    destination = "/tmp"
  }
  #executing that script to perform the server setup
  provisioner "remote-exec" {
    inline = [
      "sudo sh /tmp/assets/script.sh"
    ]
  }

    tags = {
    Name = "terraform-example"
  }

}
resource "aws_key_pair" "yordanskey" {
  key_name="yordan"
  public_key="${file("~/.ssh/id_rsa.pub")}"
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = "${var.server_port}"
    to_port     = "${var.server_port}"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  #rule to be able to transfer files to server via ssh
  ingress {
		from_port   = 22
		to_port     = 22
		protocol    = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

output "public_ip" {
  value = "${aws_instance.example.public_ip}"

}

output "public_dns" {
  value = "${aws_instance.example.public_dns}"
}
#After using taint we have made changes to the configuration of the server
#yhalachev@Yordans-MacBook-Pro provisioners (newbranch) $ curl http://ec2-18-191-219-82.us-east-2.compute.amazonaws.com:8080
#It is tainted