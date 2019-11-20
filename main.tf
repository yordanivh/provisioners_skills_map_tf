provider "aws" {
region ="us-east-2"
}

module "my-module" {
  source = "./my-modules/"

}

output "adress" {
  value = "${module.my-module.public_dns}"

}

output "dns" {
  value = "${module.my-module.public_ip}"
}
