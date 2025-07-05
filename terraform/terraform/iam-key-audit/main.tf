provider "aws" {
  region = var.region
}

resource "random_id" "suffix" {
  byte_length = 4
}
