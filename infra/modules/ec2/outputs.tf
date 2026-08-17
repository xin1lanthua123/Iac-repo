output "sonarqube_url" {

  value = "https://sast.quanldl.uk"

}


output "public_ip" {

  value = aws_instance.sonarqube.public_ip

}

output "sonarqube_elastic_ip" {
  description = "Elastic IP of SonarQube EC2"
  value       = aws_eip.sonarqube.public_ip
}

