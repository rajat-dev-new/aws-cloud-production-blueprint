# AWS ElastiCache (Redis) Replication Cluster

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnets-${var.environment}"
  subnet_ids = [aws_subnet.data_1.id, aws_subnet.data_2.id]
}

resource "aws_elasticache_replication_group" "redis_cluster" {
  replication_group_id          = "redis-${var.environment}-cluster"
  description                   = "High-availability session & token cache"
  node_type                     = "cache.r6g.large"
  num_cache_clusters            = 2
  parameter_group_name          = "default.redis7"
  port                          = 6379
  automatic_failover_enabled    = true
  multi_az_enabled              = true
  subnet_group_name             = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids            = [aws_security_group.cache_sg.id]

  at_rest_encryption_enabled    = true
  transit_encryption_enabled   = true

  tags = {
    Name        = "redis-${var.environment}-cluster"
    Environment = var.environment
  }
}
