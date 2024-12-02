terraform {
  backend "s3" {
    bucket = "terraform-backend"
    key    = "terraform/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform-state"
  }
}
