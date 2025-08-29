# Use your VPC module to create a complete network
module "main_vpc" {
  source = "../modules/vpc"
  
  vpc_name        = "main-vpc"
  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
  s3_bucket_name  = "ade1000-assets"
}

# Create ALB security group (define this FIRST since it's referenced later)
module "alb_security_group" {
  source = "../modules/security_group"
  
  name        = "alb-sg"
  description = "Allow HTTP/HTTPS to ALB"
  vpc_id      = module.main_vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP to ALB"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS to ALB"
    }
  ]
  
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic from ALB"
    }
  ]
}

# Create web server security group
module "web_security_group" {
  source = "../modules/security_group"
  
  name        = "web-server-sg"
  description = "Allow HTTP/HTTPS and SSH access"
  vpc_id      = module.main_vpc.vpc_id
  
  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS from anywhere"
    },
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow SSH from anywhere"
    }
  ]
  
  egress_rules = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}

# Create Application Load Balancer
module "web_alb" {
  source = "../modules/alb"

  name               = "web-alb"
  vpc_id             = module.main_vpc.vpc_id
  subnet_ids         = module.main_vpc.public_subnet_ids
  security_group_ids = [module.alb_security_group.security_group_id]
  enable_https       = false
}

# Create EC2 instance
module "web_server" {
  source    = "../modules/ec2"
  name      = "web-server"
  vpc_id    = module.main_vpc.vpc_id
  subnet_id = module.main_vpc.public_subnet_ids[0]
  security_group_ids = [module.web_security_group.security_group_id]
}
