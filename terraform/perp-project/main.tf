module "main_vpc" {
  source          = "../modules/vpc"
  vpc_name        = "${var.project_name}-${var.environment}"
  vpc_cidr        = "10.0.0.0/16"
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  azs             = ["us-east-1a", "us-east-1b"]

  tags = merge(var.tags, { Environment = var.environment })
}

data "aws_ssm_parameter" "al2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

module "ec2_instance" {
  source               = "../modules/ec2"
  ami_id               = data.aws_ssm_parameter.al2_ami.value
  vpc_id               = module.main_vpc.vpc_id
  name                 = var.instance_name
  instance_type        = var.instance_type
  subnet_id            = module.main_vpc.public_subnet_ids[0]
  security_group_ids   = [module.main_vpc.security_group_id]
  ssh_key_name         = var.ssh_key_name
  instance_name        = "${var.instance_name}-${var.environment}"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
  })
}
