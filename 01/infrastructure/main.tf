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
  app_lb_dns_name = module.app_alb.alb_dns_name
  iam_instance_profile = module.iam.cloudwatch_instance_profile

  depends_on = [module.app_asg]

}

module "app_asg" {
  source = "./modules/asg"
  name = "app"
  subnets = module.vpc.private_subnets
  sg = module.sg.instance_app_sg_id
  key_name = var.key_name
  alb_target_group = module.app_alb.target_group
  script_name = "install_springboot.sh"
  iam_instance_profile = module.iam.instance_profile

  depends_on = [module.secret]

}

module "nginx_alb" {
  source = "./modules/alb"
  name = "nginx"
  vpc_id = module.vpc.vpc_id
  internal = false
  # subnets = module.vpc.private_subnets
  subnets = module.vpc.public_subnets
  sg = module.sg.nginx_alb_sg_id
}

module "app_alb" {
  source = "./modules/alb"
  name = "app"
  vpc_id = module.vpc.vpc_id
  internal = true
  subnets = module.vpc.private_subnets
  sg = module.sg.nginx_alb_sg_id
}

module "rds" {
  source = "./modules/db"
  db_subnet_group_name = module.vpc.db_subnet_group_name
  sg = module.sg.rds_sg_id
  db_name = var.db_name
  username = var.db_username
  password = var.db_password
}

module "secret" {
  source = "./modules/secrets"
  username = module.rds.username
  host = module.rds.host
  port = module.rds.port
  db_name = var.db_name
  password = var.db_password
}

module "iam" {
  source = "./modules/iam"
  secret_manager_arn = module.secret.secret_manager_arn
}



#TO DO
# CHECK ALB CONNECTIVITY