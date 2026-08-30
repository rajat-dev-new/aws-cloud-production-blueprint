# ☁️ AWS Cloud Production Infrastructure & Security Hardening Blueprint

> **Enterprise Multi-AZ VPC Architecture, RDS PostgreSQL, ElastiCache Redis, Least-Privilege IAM & Automated Trivy Container Remediation**

[![AWS](https://img.shields.io/badge/AWS-Production_Ready-FF9900?style=flat-square&logo=amazon-aws&logoColor=white)](https://aws.amazon.com)
[![Terraform](https://img.shields.io/badge/Terraform-1.5+-844FBA?style=flat-square&logo=terraform&logoColor=white)](https://terraform.io)
[![Trivy](https://img.shields.io/badge/Trivy-CVE_Remediation-10B981?style=flat-square&logo=aquasec&logoColor=white)](https://trivy.dev)
[![Docker](https://img.shields.io/badge/Docker-Hardened-2496ED?style=flat-square&logo=docker&logoColor=white)](https://docker.com)

---

## 🏛️ Production Architecture Overview

This blueprint encapsulates production cloud readiness standards engineered for high-availability enterprise environments. It provides declarative **Terraform** topologies for:
1. **Multi-AZ Network Segmentation:** Dedicated Public, Private App, and Isolated Database subnets across 2 Availability Zones.
2. **Zero-Public Ingress Database Tier:** Amazon RDS PostgreSQL and AWS ElastiCache Redis clusters accept traffic strictly from application microservices.
3. **Zero-Bastion Administration:** Management and operational debugging are routed securely via **AWS Systems Manager (SSM)** rather than opening vulnerable SSH Port 22.
4. **Automated Container Security Gate:** CI/CD pipeline script leveraging **Trivy** to scan and remediate High/Critical CVEs before pushing to Amazon ECR.

---

## 📐 Network & Security Topology

```
┌──────────────────────────────────────────────────────────────────────────────────┐
│                   AWS PRODUCTION MULTI-TIER VPC TOPOLOGY                         │
└──────────────────────────────────────────────────────────────────────────────────┘
   [Internet Ingress (HTTPS :443)]
                 │
                 ▼
     [Application Load Balancer] (Public Subnets: 10.0.1.0/24, 10.0.2.0/24)
                 │
                 ▼ (Internal Port 8000)
    [ECS Container Mesh] (Private App Subnets: 10.0.10.0/24, 10.0.11.0/24)
                 │
       ┌─────────┴────────────────────────────────────────┐
       ▼ (Port 5432 - Strictly App SG)                    ▼ (Port 6379 - Strictly App SG)
[Amazon RDS PostgreSQL Multi-AZ]                [AWS ElastiCache Redis Cluster]
(Isolated Data Subnet: 10.0.20.0/24)            (Isolated Data Subnet: 10.0.21.0/24)
```

---

## 📁 Repository Structure

```
aws-cloud-production-blueprint/
├── terraform/
│   ├── vpc.tf                 # Multi-AZ VPC, subnets, route tables & NATs
│   ├── rds.tf                 # Amazon RDS PostgreSQL Multi-AZ & encryption
│   ├── elasticache.tf         # High-availability Redis replication group
│   ├── security_groups.tf     # Least-privilege ingress/egress firewall rules
│   └── iam_policies.tf        # Zero-bastion SSM roles & ECS task execution policies
├── security/
│   ├── trivy-scan.sh          # Automated container vulnerability gate
│   └── dockerfile-hardening-guidelines.md # Container hygiene standards
├── docker-compose.yml         # Local emulation of isolated data tier
└── README.md
```

---

## 🚀 Usage & Deployment

### 1. Terraform Plan & Apply
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Run Container Vulnerability Scan
```bash
chmod +x security/trivy-scan.sh
./security/trivy-scan.sh my-app:latest
```

### 3. Spin Up Local Isolated Data Tier
```bash
docker compose up -d
```

---

## 👤 Author
**Rajat Patle** — Senior Software Engineer & AI Architect
- **Interactive Portfolio:** [rajat-dev-new.github.io](https://rajat-dev-new.github.io)
- **GitHub:** [@rajat-dev-new](https://github.com/rajat-dev-new)
- **Email:** [patlerajat94@gmail.com](mailto:patlerajat94@gmail.com)
