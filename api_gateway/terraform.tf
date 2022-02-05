terraform {
  backend "s3" {
    encrypt = true
    bucket = "backend-bucket-de-grp5"
    region = "ap-southeast-2"
    key = "./terraform.tfstate"
    profile = "default"

    # Replace this with your DynamoDB table name!
    dynamodb_table = "terraform-state-lock-dynamodb"
  }
}
