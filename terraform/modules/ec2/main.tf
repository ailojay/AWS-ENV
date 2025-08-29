# Use your VPC module to create a complete network
module "main_vpc" {
  source = "../modules/vpc"
  
  vpc_name        = "main-vpc"
  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]
  s3_bucket_name  = "ade1000-assets"
}

# Create web server security group (free)
module "web_security_group" {
  source = "../modules/security_group"
  
  name        = "web-server-sg"
  description = "Allow HTTP and SSH access"
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
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]  # Warning: In production, restrict this!
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

# Create EC2 instance (t3.micro is free tier eligible)
module "web_server" {
  source    = "../modules/ec2"
  name      = "free-tier-web-server"
  vpc_id    = module.main_vpc.vpc_id
  subnet_id = module.main_vpc.public_subnet_ids[0]
  security_group_ids = [module.web_security_group.security_group_id]
}