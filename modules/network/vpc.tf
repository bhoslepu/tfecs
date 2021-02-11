module "vpc" {
  source   = "./vpc"
  env      = var.env
  cidr     = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "public_subnet" {
  source                 = "./public_subnet"
  name                   = "${var.name}-public"
  vpc_id                 = module.vpc.vpc_id
  cidr-az1               = var.public_subnet_cidr-az1
  cidr-az2               = var.public_subnet_cidr-az2
  az1                    = var.az1
  az2                    = var.az2
  env                    = var.env
  public_subnet_name-az1 = var.public_subnet_name-az1
  public_subnet_name-az2 = var.public_subnet_name-az2
}

module "private_subnet" {
  source                  = "./private_subnet"
  region                  = var.region
  name                    = "${var.name}-private"
  vpc_id                  = module.vpc.vpc_id
  cidr-az1                = var.private_subnet_cidr-az1
  cidr-az2                = var.private_subnet_cidr-az2
  az1                     = var.az1
  az2                     = var.az2
  env                     = var.env
  private_subnet_name-az1 = var.private_subnet_name-az1
  private_subnet_name-az2 = var.private_subnet_name-az2
  ngw-id                  = module.public_subnet.ngw-id
}

module "securitygroup" {
  source = "./securitygroup"
  name   = "${var.name}-SG"
  vpc_id = module.vpc.vpc_id
  cidr   = var.vpc_cidr
  env    = var.env
}

module "alb" {
  source            = "./alb"
  tfdemo-elb-sg     = module.securitygroup.tfdemo-elb-sg
  public-subnet1-id = module.public_subnet.public-subnet1
  public-subnet2-id = module.public_subnet.public-subnet2
  vpc_id            = module.vpc.vpc_id
}
