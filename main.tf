resource "aws_vpc" "vpc-terra" {
  cidr_block           = var.vpc_cidr_block # "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"

  tags = {
    Name        = var.vpc_name #"vpc-terra"
    owner       = "PROD"
    costcenter  = "Hyd-8"
    environment = var.environment
  }
}

resource "aws_subnet" "public-subnet" {
  count             = length(var.public_cidr_block)
  vpc_id            = aws_vpc.vpc-terra.id
  cidr_block        = element(var.public_cidr_block, count.index + 1)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = length(var.private_cidr_block)
  vpc_id            = aws_vpc.vpc-terra.id
  cidr_block        = element(var.private_cidr_block, count.index + 1)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw-terra" {
  vpc_id = aws_vpc.vpc-terra.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
}

resource "aws_route_table" "public-rt-terra" {
  vpc_id = aws_vpc.vpc-terra.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-terra.id
  }

  tags = {
    Name = "${var.vpc_name}-public-route-table"
  }
}

resource "aws_route_table" "private-rt-terra" {
  vpc_id = aws_vpc.vpc-terra.id

  tags = {
    Name = "${var.vpc_name}-private-route-table"
  }
}

resource "aws_route_table_association" "public-rta-terra" {
  count          = length(var.public_cidr_block)
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index + 1)
  route_table_id = aws_route_table.public-rt-terra.id
}

resource "aws_route_table_association" "private-rta-terra" {
  count          = length(var.private_cidr_block)
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index + 1)
  route_table_id = aws_route_table.private-rt-terra.id
}

resource "aws_security_group" "allow_all" {
  name        = "${var.vpc_name}-security-group"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc-terra.id

  dynamic "ingress" {
    for_each = var.ingress_value
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] # Allowing Traffic from Any IP
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-Allow-ALL"
  }
}

/*
resource "aws_s3_bucket" "sandy-preethi-00001" {
  bucket = "sandy-preet-00001"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
  #depends_on = [aws_route_table_association.rta-terra]
}

resource "aws_s3_bucket" "sandy-pree-00002" {
  bucket = "sandy-preethi-00002"

  tags = {
    Name        = "My bucket"
    Environment = "PPR"
  }
  depends_on = [aws_s3_bucket.sandy-preethi-00001]
}

resource "aws_s3_bucket" "sandy-pree-00003" {
  bucket = "sandy-preethi-00003"

  tags = {
    Name        = "My bucket"
    Environment = "PRD"
  }
  depends_on = [aws_s3_bucket.sandy-preethi-00002]
}
*/
