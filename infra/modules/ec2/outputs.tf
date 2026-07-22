output "sonarqube_url" {

  value = "http://${aws_instance.sonarqube.public_ip}:9000"

}


output "public_ip" {

  value = aws_instance.sonarqube.public_ip

}