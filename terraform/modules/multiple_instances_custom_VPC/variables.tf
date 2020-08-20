# custom-vpc
variable "cidr_vpc" { type = string }
variable "vpc_name" { type = string }

# public-subnet
variable "cidr_public_subnet" { type = string }

# web-host (EC2)
variable "web_instance_count" { type = number }

# db-host (EC2)
variable "db_instance_count" { type = number }

# Common 
variable "az" { type = string }
variable "instance_type" { type = string }
variable "ami" { type = string }
variable "ssh_key" { type = string }