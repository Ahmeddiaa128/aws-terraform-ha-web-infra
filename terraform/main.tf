module "network" {
    source = "./modules/network"
    pub_sub1_id  = module.subnet.pub_sub1_id
    pub_sub2_id  = module.subnet.pub_sub2_id
    pri_sub1_id  = module.subnet.pri_sub1_id
    pri_sub2_id  = module.subnet.pri_sub2_id

}

module "subnet" {
    source = "./modules/subnet"
    vpc_id  = module.network.vpc_id

}

module "instance" {
    source = "./modules/instance"
    pub_sub1_id  = module.subnet.pub_sub1_id
    pub_sub2_id  = module.subnet.pub_sub2_id
    pri_sub1_id  = module.subnet.pri_sub1_id
    pri_sub2_id  = module.subnet.pri_sub2_id
    pub_sg_id    = module.network.pub_sg_id
    priv_sg_id   = module.network.priv_sg_id
    alb_private_dns = module.loadbalancer.alb_private_dns
}

module "loadbalancer" {
    source = "./modules/loadbalancer"
    vpc_id       = module.network.vpc_id
    pub_sg_id    = module.network.pub_sg_id
    priv_sg_id   = module.network.priv_sg_id
    pub_sub1_id  = module.subnet.pub_sub1_id
    pub_sub2_id  = module.subnet.pub_sub2_id
    pri_sub1_id  = module.subnet.pri_sub1_id
    pri_sub2_id  = module.subnet.pri_sub2_id
    nginx1_id    = module.instance.nginx1_id
    nginx2_id    = module.instance.nginx2_id
    web1_id      = module.instance.web1_id
    web2_id      = module.instance.web2_id
}