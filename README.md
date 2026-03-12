 ## Gatus Monitoring Platform on AWS (ECS Fargate, Terraform, CI/CD)
![AWS](https://img.shields.io/badge/AWS-374151?style=flat-square)
![ECS Fargate](https://img.shields.io/badge/ECS%20Fargate-F97316?style=flat-square)
![Terraform](https://img.shields.io/badge/Terraform-4B5563?style=flat-square)
![IaC](https://img.shields.io/badge/IaC-A21CAF?style=flat-square)
![GitHub Actions](https://img.shields.io/badge/GitHub%20Actions-4B5563?style=flat-square)
![CI/CD](https://img.shields.io/badge/CI%2FCD-0284C7?style=flat-square)
![Docker](https://img.shields.io/badge/Docker-374151?style=flat-square)
![Containers](https://img.shields.io/badge/Containers-0369A1?style=flat-square)
![Security](https://img.shields.io/badge/Security-6B7280?style=flat-square)
![OIDC](https://img.shields.io/badge/OIDC-84CC16?style=flat-square)
![IAM](https://img.shields.io/badge/IAM-6B7280?style=flat-square)
![Least Privilege](https://img.shields.io/badge/Least%20Privilege-EF4444?style=flat-square)

## Architecture Diagram
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/84dfc0ec-9001-4b2c-b1f2-e0c6176383ac" />

---
## Overview 

This project demonstrates a secure, container-based monitoring platform deployed on AWS.
Infrastructure is defined using Terraform and runs on ECS Fargate behind an Application Load Balancer with HTTPS enabled via ACM.  
The platform uses GitHub Actions for automated CI/CD with OIDC-based authentication, eliminating the need for long-lived AWS credentials.
The goal of this project is to showcase real-world DevOps practices including infrastructure-as-code, secure deployments, and production-style AWS architecture.

----
## Repository Structure
```
ecs-fargate-platform
│
├─ .github/
│  └─ workflows/
│     └─ ci-cd.yml
│
├─ app/
│  └─ gatus/
│     ├─ Dockerfile
│     ├─ entrypoint.sh
│     └─ .dockerignore
│
├─ assets/
│  ├─ ecs-diagram.png
│  ├─ gatus-demo.gif
│  ├─ cicd-summary.png
│  └─ manual-cd.png
│
├─ infra/
│  ├─ main.tf
│  ├─ provider.tf
│  ├─ variables.tf
│  ├─ outputs.tf
│  ├─ locals.tf
│  ├─ data.tf
│  ├─ ssm.tf
│  ├─ .terraform.lock.hcl
│  │
│  ├─ config/
│  │  └─ config.yaml
│  │
│  └─ modules/
│     ├─ acm/
│     ├─ alb/
│     ├─ ecr/
│     ├─ ecs/
│     ├─ iam/
│     ├─ route53/
│     ├─ security-groups/
│     └─ vpc/
│
├─ .gitignore
├─ LICENSE
└─ README.md

infra/           Terraform infrastructure
app/             Containerised Gatus application
.github/         CI/CD pipeline (GitHub Actions)
assets/          Screenshots and architecture diagrams

```
## Design 
- Infrastructure defined as code
- Secure CI/CD using OIDC, eliminating long-lived credentials
- Principle of least privilege applied consistently
- Deployments based on immutable container images
- Explicit availability and cost trade-offs

-----
## Architecture Overview
The platform is deployed within a custom VPC spanning two Availability Zones and follows established AWS reference architectures commonly used in production environments:

- Public subnets hosting a multi-AZ Application Load Balancer and zonal NAT Gateway
- Private subnets running ECS Fargate tasks
- HTTPS with HTTP-to-HTTPS redirection using ACM and Route 53
- Runtime configuration stored in SSM Parameter Store
- Centralised logging through CloudWatch
- Infrastructure provisioned and managed using Terraform

## Gatus UI Running Behind ALB
![gatus monitoring](https://github.com/user-attachments/assets/6dc77b02-9ccb-4da0-8644-d410b8ecface)

----
## CI/CD Workflow

The platform uses GitHub Actions with OpenID Connect (OIDC) to securely deploy containers to AWS without storing long-lived credentials.

## Deployment Flow: 
Developer push → GitHub Actions → Docker build → ECR push → ECS deployment

Deployment pipeline:

1. Developer pushes code to the main branch
2. GitHub Actions assumes an AWS IAM role via OIDC
3. Docker image is built from the app/gatus directory
4. Image is pushed to Amazon ECR
5. ECS service is updated with a forced deployment
6. Fargate pulls the new container image
7. The service is redeployed behind the Application Load Balancer

This approach ensures:
- Secure authentication using short-lived credentials (OIDC)
- Fully automated deployments
- Immutable container releases
- No stored AWS access keys

---
## Security Design
Security was prioritised throughout the architecture:

- OIDC authentication for GitHub Actions (no static AWS keys)
- Least privilege IAM roles
- ECS tasks deployed in private subnets
- Only the ALB is publicly accessible
- HTTPS enforced using ACM TLS certificates
- Runtime configuration stored securely in SSM Parameter Store

---
## Terraform Infrastructure
Infrastructure is defined entirely using Terraform modules.
Key components:

| Component           | Purpose                       |
| ------------------- | ----------------------------- |
| VPC                 | Isolated network environment  |
| Public Subnets      | ALB and NAT gateway           |
| Private Subnets     | ECS Fargate tasks             |
| ALB                 | Ingress and HTTPS termination |
| Route53             | DNS routing                   |
| ACM                 | TLS certificate               |
| ECS Fargate         | Container runtime             |
| ECR                 | Container registry            |
| CloudWatch          | Centralised logging           |
| SSM Parameter Store | Application configuration     |

Terraform backend uses:

- S3 for remote state
- DynamoDB for state locking

---
## Container Deployment
The monitoring platform runs as a containerised service.

Container features:

- Built from a custom Dockerfile
- Uses a lightweight entrypoint script
- Configuration loaded dynamically from SSM Parameter Store
- Logs exported to CloudWatch Logs

This allows the application to be redeployed without modifying infrastructure.
---
## Example Monitoring Checks
The Gatus platform monitors several endpoints:
| Check             | Description                   |
| ----------------- | ----------------------------- |
| Frontend          | Application endpoint health   |
| Monitoring        | Internal service check        |
| GitHub API        | External dependency check     |
| Google            | Connectivity verification     |
| DNS Query         | Infrastructure DNS validation |
| Domain Expiration | Domain expiry monitoring      |
---
## What I Learned

- Designing secure AWS architectures using private subnets
- Managing Terraform state remotely with S3 and DynamoDB
- Building CI/CD pipelines with GitHub Actions
- Deploying containerised applications on ECS Fargate
- Implementing secure IAM roles with least privilege

--
## Future Improvements

Possible enhancements:
- Blue/Green deployments
- ECS auto-scaling policies
- WAF protection on ALB
- Observability with Prometheus/Grafana
- Multi-environment deployments (dev/staging/prod)
--
## License

This project is licensed under the MIT License.
