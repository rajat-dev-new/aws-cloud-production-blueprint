# Security Group Topology: Strict Least-Privilege Network Ingress

# ALB Security Group (Public Ingress)
resource "aws_security_group" "alb_sg" {
  name        = "sg-${var.environment}-alb"
  description = "Permit inbound HTTPS from public"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "TLS from internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Forward to app microservices"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.10.0/24", "10.0.11.0/24"]
  }
}

# App Microservices Security Group
resource "aws_security_group" "app_sg" {
  name        = "sg-${var.environment}-app"
  description = "Permit traffic strictly from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Traffic from ALB only"
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Database Security Group (Zero Public Ingress)
resource "aws_security_group" "db_sg" {
  name        = "sg-${var.environment}-database"
  description = "Permit PostgreSQL port strictly from App layer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "PostgreSQL from App Microservices only"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
}

# Redis Cache Security Group
resource "aws_security_group" "cache_sg" {
  name        = "sg-${var.environment}-cache"
  description = "Permit Redis port strictly from App layer"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "Redis from App Microservices only"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }
}
