variable "region" {
    description = "AWS region"
    default = "us-east-1"
}

variable "cidr_block" {
    description = "cidr block range for vpc"
    default = "10.0.0.0/16"
  
}

variable "cidr_subnet1" {
    description = "cidr range for subnet 1"
    default = "10.0.0.0/24"
}

variable "availability_zone_subnet1" {
    description = "subnet 1 availability zone"
    default = "us-east-1b"
}

variable "cidr_subnet2" {
    description = "cidr range for subnet 2"
    default = "10.0.1.0/24"
}

variable "availability_zone_subnet2" {
    description = "subnet 2 availibility zone"
    default = "us-east-1a"
}


variable "instance_type"{
    description = "instance type"
    default = "t2.micro"
}


