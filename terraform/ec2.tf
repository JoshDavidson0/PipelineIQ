# ec2.tf defines the public subnet for the ec2 instance and internet gateway necessary for the VP

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.3.0/24"
    availability_zone = data.aws_availability_zones.available.names[0]
    map_public_ip_on_launch = true

    tags = {
        Name = "${var.project_name}-public"
    }
}

resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "${var.project_name}-igw"
    }
}