data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [
    "099720109477"
  ]
  filter {
    name = "name"
    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    ]
  }
}


resource "aws_security_group" "sonarqube_sg" {
  name = "sonarqube-security-group"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "42.113.184.4/32"
    ]
  }


  ingress {
    from_port = 9000
    to_port = 9000
    protocol = "tcp"
    cidr_blocks = [
      "42.113.184.4/32"
    ]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks=[
      "0.0.0.0/0"
    ]
  }
}



resource "aws_instance" "sonarqube" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = var.key_name
  vpc_security_group_ids = [
    aws_security_group.sonarqube_sg.id
  ]
  root_block_device {

    volume_size = 20

    volume_type = "gp3"
  }
  user_data = file("userdata.sh")
  tags = {
    Name = "sonarqube-server"
    Environment = "cicd"
  }

}