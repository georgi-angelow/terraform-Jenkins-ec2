resource "aws_key_pair" "example" {
  key_name   = "example-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
  }

resource "aws_instance" "my_jenkins" {
  ami                    = var.ami
  instance_type          = "t3.large"
  key_name               = aws_key_pair.example.key_name
  subnet_id              = aws_subnet.main.id
  security_groups        = [aws_security_group.allow_inbound_http.id , aws_security_group.allow_outbound_traffic.id]
    
  root_block_device {
    volume_size           = "50"
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name = "my_jenkins"
  }
  volume_tags = {
    Name = "my_jenkins_volume"
  }

  provisioner "remote-exec" { 
    inline = [
      "sudo yum -y update",
      "sudo yum install -y amazon-linux-extras java-1.8.0-openjdk",
      "sudo amazon-linux-extras install epel -y",
      "sudo yum -y update",
      "sudo yum -y install wget",
      "sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo",
      "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
      "sudo yum -y upgrade ",
      "sudo yum install jenkins -y",
      "sudo systemctl start jenkins",
    ]
}

  connection {
    type = "ssh"
    user = "ec2-user"
    password = ""
    host        = aws_instance.my_jenkins.public_dns
    private_key = file("id_rsa")
    }
}