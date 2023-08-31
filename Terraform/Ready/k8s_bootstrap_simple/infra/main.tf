
module "compute" {
  source = "./aws_modules/compute"

}

module "network" {
  source = "./aws_modules/network"
  
}