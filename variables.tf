variable "cidr" {
  default = "10.0.0.0/16"
  
} 
variable "sub1_cidr" {
  default = "10.0.0.0/24"
}

variable "sub2_cidr" {
  default = "10.0.1.0/24"
}

variable "ubuntu_ami" {
  default = "ami-0261755bbcb8c4a84"
}

variable "instance" {
  default = "t2.micro"
  
}