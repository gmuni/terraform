provider "aws" {
  region     = "us-east-1"
  access_key = "youraccesskey"
  secret_key = "yoursecretkey"
}

resource "aws_s3_bucket" "b" {
    bucket = "s3terraformmcr"
}
