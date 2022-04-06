data "aws_key_pair" "acg-key-pair" {
  key_name = "acg-ed25519"
}
resource "aws_vpc" "default-vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "public" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.default-vpc.id
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "acg-gateway" {
  vpc_id = aws_vpc.default-vpc.id
}

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.default-vpc.id
}

resource "aws_route_table_association" "public-egress" {
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = aws_subnet.public.id
}

resource "aws_route" "public-route" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.acg-gateway.id
  route_table_id         = aws_route_table.public-route-table.id
}

resource "aws_security_group" "acg-ingress" {
  name   = "acg-ingress"
  vpc_id = aws_vpc.default-vpc.id

  ingress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["136.49.54.194/32"]
  }
}

resource "aws_instance" "acg-instance" {
  ami                         = "ami-0c02fb55956c7d316"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.acg-ingress.id]
  key_name                    = data.aws_key_pair.acg-key-pair.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.public.id
}