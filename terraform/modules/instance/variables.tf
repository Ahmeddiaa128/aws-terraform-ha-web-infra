variable "pub_sub1_id" {}
variable "pub_sub2_id" {}

variable "pri_sub1_id" {}
variable "pri_sub2_id" {}

variable "pub_sg_id" {}
variable "priv_sg_id" {}

variable "alb_private_dns" {}

variable "ec2type" {
  default = "t2.micro"
}

variable "ec2key" {
  default = "key"
}


