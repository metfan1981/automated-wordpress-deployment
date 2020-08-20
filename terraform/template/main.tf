provider "aws" {
  profile = "default"
  region  = "eu-central-1"
}

module "multiple_instances_custom_VPC" {

  source = "../modules/multiple_instances_custom_VPC"

  #VPC
  cidr_vpc = "10.10.0.0/16"
  vpc_name = "test-task_vpc"

  #Subnet Public 
  cidr_public_subnet = "10.10.10.0/24"
  
  #EC2
  web_instance_count = 1
  db_instance_count = 1
  instance_type = "t2.micro"
  ami           = "ami-0130bec6e5047f596"
  ssh_key       = "guest"
  az            = "eu-central-1b"
}
