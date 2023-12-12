resource "aws_iam_role" "example_role" {
  name = "Jenkins-terraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "example_attachment" {
  role       = aws_iam_role.example_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_instance_profile" "example_profile" {
  name = "Jenkins-terraform"
  role = aws_iam_role.example_role.name
}

resource "aws_vpc" "project_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = "project"
  }
}

resource "aws_subnet" "project_public_subnet" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "project"
  }
}

resource "aws_internet_gateway" "project_internet_gateway" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "project-igw"
  }
}

resource "aws_route_table" "project_public_rt" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "project_public_rt"
  }
}

resource "aws_route" "project_route" {
  route_table_id         = aws_route_table.project_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.project_internet_gateway.id
}

resource "aws_route_table_association" "project_public_assoc" {
  subnet_id      = aws_subnet.project_public_subnet.id
  route_table_id = aws_route_table.project_public_rt.id
}


resource "aws_security_group" "Jenkins-sg" {
  name        = "Jenkins-Security Group"
  description = "Open 22,443,80,8080,9000"
  vpc_id      = aws_vpc.project_vpc.id

  # Define a single ingress rule to allow traffic on all specified ports
  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "TLS from VPC"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-sg"
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-0f5ee92e2d63afc18"
  instance_type          = "t2.large"
  key_name               = "EC2-key"
  vpc_security_group_ids = [aws_security_group.Jenkins-sg.id]
  subnet_id              = aws_subnet.project_public_subnet.id
  user_data              = templatefile("./install_jenkins.sh", {})
  iam_instance_profile   = aws_iam_instance_profile.example_profile.name

  tags = {
    Name = "Jenkins-ARGO"
  }

  root_block_device {
    volume_size = 30
  }
}
