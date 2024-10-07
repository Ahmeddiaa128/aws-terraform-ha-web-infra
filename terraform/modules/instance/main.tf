data "aws_ami" "amz_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}


locals {
  public_instances = {
    "nginx_1" = {
      subnet_id      = var.pub_sub1_id
      instance_name  = "nginx_1"
    }
    "nginx_2" = {
      subnet_id      = var.pub_sub2_id
      instance_name  = "nginx_2"
    }
  }

  private_instances = {
    "apache_1" = {
      subnet_id      = var.pri_sub1_id
      instance_name  = "apache_1"
      file_source    = file("${path.root}/web1/index.html")
    }
    "apache_2" = {
      subnet_id      = var.pri_sub2_id
      instance_name  = "apache_2"
      file_source    = file("${path.root}/web2/index.html") 
    }
  }
}

# NGINX Instances
resource "aws_instance" "nginx" {
  for_each                     = local.public_instances
  ami                          = data.aws_ami.amz_linux.id
  instance_type                = var.ec2type
  associate_public_ip_address   = true
  key_name                     = var.ec2key
  subnet_id                    = each.value.subnet_id
  security_groups              = [var.pub_sg_id] 

  provisioner "local-exec" {
    command = "echo ${each.value.instance_name} Public IP ${self.public_ip} >> all-ips.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install nginx -y",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
      <<EOF
      echo 'server {
        listen 80;
        location / {
          proxy_pass http://${var.alb_private_dns};
        }
      }' | sudo tee /etc/nginx/conf.d/reverse-proxy.conf
      EOF
      ,"sudo systemctl restart nginx"
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("${path.root}/secret/key.pem")
    host        = self.public_ip
  }

  tags = {
    Name = each.value.instance_name
  }
}

# Apache Instances
resource "aws_instance" "apache" {
  for_each                     = local.private_instances
  ami                          = data.aws_ami.amz_linux.id
  instance_type                = var.ec2type
  key_name                     = var.ec2key
  subnet_id                    = each.value.subnet_id
  security_groups              = [var.priv_sg_id] 
  provisioner "local-exec" {
    command = "echo ${each.value.instance_name} Private IP ${self.private_ip} >> all-ips.txt"
  }

  provisioner "file" {
    source      = each.value.file_source
    destination = "/tmp/index.html"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/secret/key.pem")
      host        = self.private_ip
      bastion_user = "ec2-user"
      bastion_private_key = file("${path.root}/secret/key.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install httpd -y",
      "sudo systemctl enable httpd",
      "sudo systemctl start httpd",
      "sudo mv /tmp/index.html /var/www/html/index.html",
      "sudo systemctl restart httpd"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("${path.root}/secret/key.pem") 
      host        = self.private_ip
      bastion_user = "ec2-user"
      bastion_private_key = file("${path.root}/secret/key.pem")
    }
  }

  tags = {
    Name = each.value.instance_name
  }
}


