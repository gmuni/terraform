terraform {
  backend "s3" {
      bucket = "forterraform2"
      key = "environments/terraform.tfstate"
      region = "us-west-2"
      dynamodb_table = "qtterraformlocks"

      workspaces {
          prefix = "lt-eapp-"
      }

  }
}
