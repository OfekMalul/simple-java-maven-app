terraform {
  backend "s3" {
    bucket = "ofek-malul-terraform-bucket"
    key    = "terraform/terraform-java-hellowolrd-project"
    region = "us-east-1"
  }
}