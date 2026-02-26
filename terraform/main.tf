# main.tf defines the providers Terraform will need to download.
# hashicorp/aws informs terraform of AWS resources and how they work.
# hashicorp/random will generate a random 4 character hex suffix to increase the chances of producing a unique s3 bucket name.
terraform {

  required_providers {

    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }

    random = {
        source = "hashicorp/random"
        version = "~> 3.0"
    }

  }

}

# Terraform configures a connection with AWS after the providers have been downloaded using the aws_region variable defined in variables.tf

provider "aws" {
    region = var.aws_region
}

