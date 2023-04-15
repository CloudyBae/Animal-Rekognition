# create vpc
resource "aws_vpc" "animalrekog_vpc" {
  cidr_block = "${var.vpc_cidr_block}"

  tags = {
    Name = "animalrekog_vpc"
  }
}

# create public subnet
resource "aws_subnet" "public_subnet" {
  count = length(var.public_subnet_cidr_blocks)

  cidr_block = var.public_subnet_cidr_blocks[count.index]
  vpc_id     = aws_vpc.animalrekog_vpc.id

  tags = {
    Name = "animalrekog_public_subnet_${count.index + 1}"
  }
}

# create private subnet
resource "aws_subnet" "private_subnet" {
  count = length(var.private_subnet_cidr_blocks)

  cidr_block = var.private_subnet_cidr_blocks[count.index]
  vpc_id     = aws_vpc.app_vpc.id

  tags = {
    Name = "animalrekog_private_subnet_${count.index + 1}"
  }
}

# create internet gateway
resource "aws_internet_gateway" "animalrekog_igw" {
  vpc_id = aws_vpc.animalrekog_vpc.id
}

# create nat gateway
resource "aws_nat_gateway" "animalrekog_natgw" {
  count = length(var.public_subnet_cidr_blocks)

  allocation_id = aws_eip.animalrekog_eip[count.index].id
  subnet_id     = aws_subnet.public_subnet[count.index].id

  tags = {
    Name = "animalrekog_natgw_${count.index + 1}"
  }
}

resource "aws_eip" "animalrekog_eip" {
  count = length(var.public_subnet_cidr_blocks)
  vpc = true

  tags = {
    Name = "animalrekog_eip_${count.index + 1}"
  }
}

# create route tables
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.animalrekog_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.animalrekog_igw.id
  }

  tags = {
    Name = "animalrekog_public_rt"
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.animalrekog_vpc.id

  tags = {
    Name = "animalrekog_private_rt"
  }
}

# subnet association with route tables
resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidr_blocks)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidr_blocks)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}