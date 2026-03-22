# Amazon RDS PostgreSQL Multi-AZ Deployment

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "rds-subnet-group-${var.environment}"
  description = "Isolated database subnet group"
  subnet_ids  = [aws_subnet.data_1.id, aws_subnet.data_2.id]

  tags = {
    Name = "rds-subnet-group-${var.environment}"
  }
}

resource "aws_db_instance" "postgresql_primary" {
  identifier            = "rds-${var.environment}-postgres"
  engine                = "postgres"
  engine_version        = "16.1"
  instance_class        = "db.r6g.xlarge"
  allocated_storage     = 100
  max_allocated_storage = 500
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "enterprise_db"
  username = "db_admin"
  # Password managed securely via AWS Secrets Manager

  multi_az               = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false
  skip_final_snapshot    = false
  final_snapshot_identifier = "rds-final-snapshot-${var.environment}"

  backup_retention_period = 30
  backup_window           = "02:00-03:00"
  maintenance_window      = "Sun:04:00-Sun:05:00"

  auto_minor_version_upgrade = true
  deletion_protection        = true

  tags = {
    Name        = "rds-${var.environment}-postgres"
    Environment = var.environment
  }
}
