# ec2.tf - EC2 instance resource
resource "aws_instance" "web_server" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  key_name               = "KWBkey"
  vpc_security_group_ids = [aws_security_group.web_servers.id]
  subnet_id              = aws_subnet.public_subnet_1.id

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo echo "<html><body><h1>Welcome to my NGINX Web Server!</h1></body></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Web Server 1"
  }
}

resource "aws_instance" "web_server_2" {
  ami                    = "ami-007855ac798b5175e"
  instance_type          = "t2.micro"
  key_name               = "KWBkey"
  vpc_security_group_ids = [aws_security_group.web_servers.id]
  subnet_id              = aws_subnet.public_subnet_2.id

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update -y
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              sudo echo "<html><body><h1>Welcome to my NGINX Web Server!</h1></body></html>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "Web Server 2"
  }
}