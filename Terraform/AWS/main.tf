// VPC Creation

/*==== VPC for Instance ======*/
resource "aws_vpc" "vpc_instance" {
  cidr_block           = var.VPC_CIDR_INSTANCE
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.PROJECT}-vpc-instance"
  }
}

/* Internet gateway for the public subnet */
resource "aws_internet_gateway" "ig_instance" {
  vpc_id = aws_vpc.vpc_instance.id

  tags = {
    Name        = "${var.PROJECT}-igw-instance"
  }
}

/* Public subnet */
resource "aws_subnet" "public_subnet_instance" {
  vpc_id                  = aws_vpc.vpc_instance.id
  count                   = length(var.PUBLIC_SUBNETS_CIDR_INSTANCE)
  cidr_block              = element(var.PUBLIC_SUBNETS_CIDR_INSTANCE, count.index)
  availability_zone       = element(var.AVAILABILITY_ZONE, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.PROJECT}-${element(var.AVAILABILITY_ZONE, count.index)}-public-subnet-instance"
  }
}

/* Routing table for public subnet */
resource "aws_route_table" "public_instance" {
  vpc_id = aws_vpc.vpc_instance.id

  tags = {
    Name        = "${var.PROJECT}-public-instance-route-table"
  }
}

resource "aws_route" "public_instance_internet_gateway" {
  route_table_id         = aws_route_table.public_instance.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig_instance.id
}

/* Route table associations */
resource "aws_route_table_association" "public_instance" {
  count          = length(var.PUBLIC_SUBNETS_CIDR_INSTANCE)
  subnet_id      = element(aws_subnet.public_subnet_instance.*.id, count.index)
  route_table_id = aws_route_table.public_instance.id
}

/*==== VPC's Default Security Group ======*/
resource "aws_security_group" "instance_sg" {
  name        = "${var.PROJECT}-instance-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = aws_vpc.vpc_instance.id
  depends_on  = [aws_vpc.vpc_instance]

  /* Allow only ssh traffic from internet */
  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  /* Allow all outbound traffic to internet */
  egress {
    from_port        = "0"
    to_port          = "0"
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

// EC2 Creation

#AWS Instance
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

 resource "aws_instance" "instance" {

    ami                         = data.aws_ami.ubuntu.id
    instance_type               = var.INSTANCE_TYPE
    key_name                    = var.KEY
    subnet_id                   = element(aws_subnet.public_subnet_instance.*.id, 0)
    vpc_security_group_ids      = [aws_security_group.instance_sg.id]
    associate_public_ip_address = true

    root_block_device {
    volume_type            = "gp2"
    volume_size            = "20"
    delete_on_termination  = true
  }

    ebs_block_device {
    device_name = "/dev/sdb"
    volume_size = "8"
    volume_type = "gp2"
  }
}

// S3 Creation

resource "aws_s3_bucket" "application_bucket" {
  bucket = "${var.bucket_name}"
  acl    = "private"
  
  versioning {
    enabled = false
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "POST", "PUT"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "application_bucket" {
  bucket = aws_s3_bucket.application_bucket.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_public_access_block" "application_bucket" {
  bucket = aws_s3_bucket.application_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

output "s3_bucket_name" {
  value = aws_s3_bucket.application_bucket.bucket
}