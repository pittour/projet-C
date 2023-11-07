provider "aws" {
  region = "eu-west-1"
  default_tags {
    tags = {
      owner = "kbillerach@thenuumfactory.fr"
      ephemere = "non"
      entity = "numfactory"
    }
  }
}

terraform {
  backend "s3" {
    bucket = "kebi-s3"
    key = "drupal.tfstate"
    region = "eu-west-1"
  }
}