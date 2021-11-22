terraform {
  backend "s3" {
      bucket = "forterraform1"
      key = "terraform.tfstate"
      region = "us-west-2"
      dynamodb_table = "qtterraformlocks"

  }
}