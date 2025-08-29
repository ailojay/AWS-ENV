# providers.tf
provider "aws" {
  region = "us-east-1"
}

# main.tf
resource "aws_vpc" "training_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "Training-VPC"
  }
}

output "vpc_id" {
  value = aws_vpc.training_vpc.id
}
