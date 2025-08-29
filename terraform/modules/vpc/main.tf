resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  
  tags = merge(
    {
      Name      = var.vpc_name
      ManagedBy = "Terraform"
    },
    var.s3_bucket_name != "" ? { S3Bucket = var.s3_bucket_name } : {}
  )
}

# ... rest of your VPC resources (subnets, IGW, route tables, etc.)

resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index % length(var.azs)]
  
  tags = {
    Name = "${var.vpc_name}-public-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  
  tags = {
    Name = "${var.vpc_name}-igw"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
  
  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}