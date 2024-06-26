resource "aws_security_group" "public_sg" {
  name        = "public-sg"
  description = "Security group for EC2 instance with public IP"
  depends_on = [aws_vpc.main]
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.public_sg_tag
}

resource "aws_security_group" "private_sg" {
  name        = "private-sg"
  description = "Security group for EC2 instances without public IP"
  depends_on = [aws_vpc.main]
  vpc_id      = aws_vpc.main.id

ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.custom_port
    to_port     = var.custom_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.private_sg_tag
}


resource "aws_security_group" "postgresql_sg" {
  name        = "rds-sg"
  description = "Allow SSH and PostgressQL traffic"
  depends_on  = [aws_vpc.main]
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow traffic from any IP address
  }

  ingress {
    from_port   = var.postgressql_port
    to_port     = var.postgressql_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # allow traffic from any IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # allow traffic to any IP address
  }

  tags = var.rds_sg_tag
}


resource "aws_security_group" "load_balancer_sg" {
  name        = "load-balancer-sg"
  description = "Allow HTTP and HTTPS traffic"
  depends_on = [aws_vpc.main]
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = var.http_port
    to_port     = var.http_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.https_port
    to_port     = var.https_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.load_balancer_sg_tag
}