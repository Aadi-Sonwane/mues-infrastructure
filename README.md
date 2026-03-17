# 🚀 AWS 2-Tier Modular Infrastructure (Terraform)

> Production-grade, highly available, and cost-optimized AWS infrastructure for deploying a **React + Django** application using Terraform.

---

## 📌 Project Summary

This project demonstrates how to design and deploy a **scalable, secure, and cost-efficient cloud architecture** using Terraform and AWS best practices.

🔹 Built a **2-tier architecture** with clear separation of concerns  
🔹 Achieved **High Availability (Multi-AZ deployment)**  
🔹 Implemented **Zero-Trust Security using AWS SSM (No SSH)**  
🔹 Reduced infrastructure cost using **70% Spot Instances strategy**  
🔹 Designed **fully modular Terraform code** for reusability  

---

## 🏗️ Architecture Overview

### 🔹 Key Components

- **VPC** with 4 subnets across 2 Availability Zones  
- **Public ALB** → Handles incoming HTTPS traffic  
- **Private React App** → Served via ALB  
- **Internal NLB** → Backend communication layer  
- **Private Django API** → Only accessible internally  
- **External MongoDB** → Secure connection via SSM  

---

## 🧠 Architecture Decisions (Why This Design?)

| Decision | Reason |
|--------|--------|
| ALB + NLB combo | ALB for HTTP routing, NLB for high-performance internal traffic |
| Private Subnets | No direct exposure → improved security |
| SSM over SSH | Eliminates key management & reduces attack surface |
| Mixed Instances Policy | Balances cost + availability |
| Modular Terraform | Reusable, scalable, production-ready code |

---

## 📁 Project Structure

```plaintext
.
├── backend-setup/            # S3 + DynamoDB (Remote State)
├── modules/                  # Reusable Terraform modules
│   ├── vpc/
│   ├── security/
│   ├── lb/
│   ├── compute/
│   └── dns_secrets/
└── environments/
    ├── dev/
    └── prod/
```
---
## 🔐 Core Features
1. Zero-Trust Access (SSM)

    ❌ No SSH (Port 22 disabled)

    ❌ No Bastion Host
```sh
aws ssm start-session --target <instance-id>
```

 - Secrets stored in SSM Parameter Store (SecureString)

 - Retrieved dynamically using IAM Roles

2. Traffic Management
🌍 Application Load Balancer (ALB)

Public-facing

SSL termination

Routes traffic to frontend

🔁 Network Load Balancer (NLB)

Internal-only

Static endpoint for backend communication

High throughput & low latency

3. 💰 Cost Optimization

70% Spot Instances

30% On-Demand Instances

Strategy: capacity-optimized

💡 Result: Significant cost savings while maintaining reliability

## ⚙️ Deployment Guide
### Step 1: Setup Remote Backend
```sh
cd backend-setup
terraform init
terraform apply
```

Creates:

- S3 bucket (state storage)

- DynamoDB (state locking)

### Step 2: Deploy Environment
```sh
cd environments/dev   # or prod
```

Update variables:
```hcl
instance_type = "t3.micro"
domain_name   = "yourdomain.com"
mongo_url     = "your-mongodb-url"
```

Deploy:
```sh
terraform init
terraform plan
terraform apply
```

#### 🔐 Security Model
| Component  | Port | Access         |
| ---------- | ---- | -------------- |
| ALB        | 443  | Internet       |
| React App  | 80   | ALB only       |
| Django API | 8000 | Internal (NLB) |
| SSH        | ❌   | Disabled       |

---
### 📈 Scaling & Updates
Scaling
```hcl
desired_capacity = 3
```
```hcl
terraform apply
```

### Rolling Updates

Update __ami_id__ or User Data

ASG triggers:

* Instance Refresh
* Zero-downtime rollout

---
📊 Impact & Outcomes

✅ Improved security by removing SSH access entirely\
✅ Reduced infrastructure cost using Spot strategy\
✅ Achieved high availability across multiple AZs\
✅ Built reusable Terraform modules for faster deployments\
✅ Designed production-grade infra aligned with real-world systems\

---
#### 🛠️ Tech Stack

- Cloud: AWS (EC2, ALB, NLB, VPC, SSM, Route53, ACM)

- IaC: Terraform

- Compute: Auto Scaling Groups, Launch Templates

- Security: IAM Roles, SSM Parameter Store

- Monitoring (Planned): Prometheus, Grafana
---
#### 📌 Future Enhancements

🔄 CI/CD Pipeline (GitHub Actions / Jenkins)

📊 Monitoring (Prometheus + Grafana)

🛡️ AWS WAF integration

🔵🟢 Blue/Green deployments

📦 Containerization (EKS / ECS migration)

#### 👨‍💻 Author

Aditya Sonwane
DevOps Engineer | AWS | Terraform | Kubernetes