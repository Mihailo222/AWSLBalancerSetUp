terraform {
    #provider versions and source of API of provider
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "5.11.0"
    }
  }
  #remote backend on s3
  #no access keys here (only on aws-cli command)

}

provider "aws" {
  region = "us-east-1"
  
}

#terraform init - initializing terraform-verifikacija da sam ja konektovan na aws preko terraforma
#terraform validate -> compiling errors !!!