module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
  environment = var.environment
}

module "sg" {
  source = "./modules/security"
  vpc_id = module.vpc.vpc_id
  key_name = var.key_name
}

module "nginx_asg" {
  source = "./modules/asg"
  name = "nginx"
  # subnetqs = module.vpc.private_subnets
  subnets = module.vpc.public_subnets
  sg = module.sg.instance_nginx_sg_id
  key_name = var.key_name
  alb_target_group = module.nginx_alb.target_group
  script_name = "install_nginx.sh"
}

module "app_asg" {
  source = "./modules/asg"
  name = "app"
  # subnetqs = module.vpc.private_subnets
  subnets = module.vpc.public_subnets
  sg = module.sg.instance_nginx_sg_id
  key_name = var.key_name
  alb_target_group = module.nginx_alb.target_group
  script_name = "install_springboot.sh"
}

module "nginx_alb" {
  source = "./modules/alb"
  name = "nginx"
  vpc_id = module.vpc.vpc_id
  internal = true
  # subnets = module.vpc.private_subnets
  subnets = module.vpc.public_subnets
  sg = module.sg.nginx_alb_sg_id
}

module "app_alb" {
  source = "./modules/alb"
  name = "app"
  vpc_id = module.vpc.vpc_id
  internal = false
  subnets = module.vpc.private_subnets
  # subnets = module.vpc.public_subnets
  sg = module.sg.nginx_alb_sg_id
}