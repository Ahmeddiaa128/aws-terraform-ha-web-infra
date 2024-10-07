# aws-terraform-ha-web-infra

![terraa](https://github.com/user-attachments/assets/44494013-6ff5-4b6a-8ae2-db496c296ffc)


## Project Description

This Terraform setup provisions a highly available web application infrastructure within AWS, using EC2 instances distributed across multiple 
availability zones. Using NLB in front of the NGINX proxy servers to distribute incoming traffic evenly across both public subnets,and ALB in 
front of the APACHE web servers for distributing traffic to the private web servers . 