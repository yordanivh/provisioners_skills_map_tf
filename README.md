# provisioners_skills_map_tf
This Repo contains TF examples for provisioners

## What provisioners do

Provisioners as you can expect from the name can help with provisioning of a server.
In this repo I have shown two examples of using provisioners

```
  provisioner "file" {
    source = "assets"
    destination = "/tmp"
  }
 ```
 this provsioner uploads a file from a source to destiantion on the resource
 
 ```
   provisioner "remote-exec" {
    inline = [
      "sudo sh /tmp/assets/script.sh"
    ]
  }
  ```
  This one executes a command to run a script which is uploaded by file provisioner on the resource
  
## How to use this code

To be able to use these provisioners it is necessary to have a connection to your resource instance established.
To do that you need to have ssh connection by using the `connection` argument in the resource code.

```
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
```
You have to create a `aws_key_pair` resource and by using it, you establish the ssh connection to use the provisioners



