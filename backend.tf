terraform {
  backend "s3" {
    bucket = "terraform-backend"
    key    = "three-tier/terraform.tfstate"
    region = "eu-west-1"
    dynamodb_table = "terraform-state"
  }
}
