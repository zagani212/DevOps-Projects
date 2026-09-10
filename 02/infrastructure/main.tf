module "bastion_vpc" {
  source = "./modules/vpc"
  name = "bastion"
  vpc_cidr = var.bastion_vpc_cidr
  public_subnet_cidr = var.bastion_public_subnet_cidr
} 

module "app_vpc" {
  source = "./modules/vpc"
  name = "app"
  vpc_cidr = var.app_vpc_cidr
  public_subnet_cidr = var.app_public_subnet_cidr
  private_subnet_cidr = var.app_private_subnet_cidr
} 

module "key" {
  source = "./modules/keys"
}

module "sg" {
  source = "./modules/security"
  app_vpc_id = module.app_vpc.vpc_id
  bastion_vpc_id = module.bastion_vpc.vpc_id
  bastion_cidr = var.bastion_vpc_cidr
}

module "bastion" {
  source = "./modules/computing"
  ami           = var.ami
  instance_type = var.instance_type
  key_name = module.key.key_name
  sg = module.sg.bastion_sg
  subnet_id = module.bastion_vpc.public_subnet[0].id
}

module "app" {
  source = "./modules/computing"
  ami           = var.ami
  instance_type = var.instance_type
  key_name = module.key.key_name
  sg = module.sg.app_sg
  subnet_id = module.app_vpc.private_subnet[0].id
}


module "transit_gateway" {
  source = "./modules/transit_gateway"
  vpc_id_a = module.bastion_vpc.vpc_id
  vpc_id_b = module.app_vpc.vpc_id
  vpc_cidr_a = var.bastion_vpc_cidr
  vpc_cidr_b = var.app_vpc_cidr
  subnet_a = module.bastion_vpc.public_subnet[*].id
  subnet_b = module.app_vpc.private_subnet[*].id
  rt_a = module.bastion_vpc.public_rt[*].id
  rt_b = module.app_vpc.private_rt[*].id
}