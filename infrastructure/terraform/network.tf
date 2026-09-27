data "aws_vpc" "default" {
  id = "vpc-993cf1e4"
}

data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_subnet" "shipping_dev" {
  vpc_id                  = data.aws_vpc.default.id
  cidr_block              = "172.31.96.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "shipping-api-dev"
    Project = "aws-cloud-native-cicd-lab"
  }
}

resource "aws_route_table" "shipping_dev" {
  vpc_id = data.aws_vpc.default.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = data.aws_internet_gateway.existing.id
  }

  tags = {
    Name    = "shipping-api-dev-public"
    Project = "aws-cloud-native-cicd-lab"
  }
}

resource "aws_route_table_association" "shipping_dev" {
  subnet_id      = aws_subnet.shipping_dev.id
  route_table_id = aws_route_table.shipping_dev.id
}