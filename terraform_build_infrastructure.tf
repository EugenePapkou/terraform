provider "aws" {
  region                  = "${var.region}"
  profile                 = "default"
}

variable "region" {
  default = "us-east-1"
}

variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-05378f41110822767"
    "us-east-2" = "ami-03c602070acf08b27"
  }
}

resource "aws_instance" "papkou" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  depends_on = ["aws_s3_bucket.s3_papkou"]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.papkou.id}"

provisioner "local-exec" {
  command = "echo ${aws_eip.ip.public_ip} >> ip_address.txt"
  on_failure = "continue"
}
}

resource "aws_s3_bucket" "s3_papkou" {
  bucket = "s3-papkou-task4-2"
  acl    = "private"
}

output "ip" {
  value = "${aws_eip.ip.public_ip}"
}

