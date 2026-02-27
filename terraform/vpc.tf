# vpc.tf defines the private network the rds database will be in.

# The goal here is the define a range of private IP addresses and allow the vpc to resolve AWS service hostnames to IP addresses
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    tags = { Name = "${var.project_name}-vpc" }
  
}

# The goal here is to ask AWS which availability zones are available in the region.
data "aws_availability_zones" "available" {
    state = "available"
}

# The goal here is to create 2 private subnets, each in a different availability zone, for high availability.
# Also to select the first two availability zones available reference data source "aws_availability_zones."
resource "aws_subnet" "private" {
    count = 2
    vpc_id = aws_vpc.main
    cidr_block = "10.0${count.index + 1}.0/24"
    availability_zone = data.aws_availability_zones.available.names[count.index]
    tags = { Name = "${var.project_name}-private-${count.index}"}
  
}

# The goal here is to select the id of every subnet in the list.
resource "aws_db_subnet_group" "main" {
    name = "${var.project_name}-subnet-group"
    subnet_ids = aws_subnet.private[*].id
    tags = { Project = var.project_name}
}

# The goal here is to add a security group as a second layer of defense.
# Only traffic incoming from the Postgres port and IP inside the VPC range may enter.
# Outbound traffic can go wherever necessary.
resource "aws_security_group" "rds" {
    name = "${var.project_name}-rds-sg"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 5432
        to_port = 5432
        protocol = "tcp"
        cidr_blocks = ["10.0.0.0/16"]
    }

    egress = {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = { Name = "${var.project_name}-rds-sg"}
}