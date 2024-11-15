terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.76.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      Environment = var.environment
      Terraform   = "true"
      Stack       = local.stack_name
    }
  }
}

terraform {
  backend "s3" {
    bucket         = "mycelium-terraform"
    key            = "deno-aws-terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
  }
}