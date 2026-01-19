# CSTrader - Terraform Deployment

This project deploys the CSTrader application using Terraform for Infrastructure as Code, replacing the previous YAML-based Kubernetes manifests.

## How this exercise relates to the previous one

The previous exercise used Kubernetes YAML manifests applied with `kubectl`, along with a Makefile for automation. This version uses Terraform to provision the Minikube cluster and deploy all Kubernetes resources (namespaces, deployments, services, ingress, etc.), ensuring declarative and version-controlled infrastructure.

## What is reused and what is different

### Reused:
- Application architecture: 3-tier (Frontend Nginx, Backend FastAPI, Database PostgreSQL).
- Docker images and code (backend/, frontend/).
- Environment variables and secrets.
- Minikube for local cluster.
- HTTPS with self-signed certificates.
- Database migrations and admin seeding via Jobs.

### Different:
- Infrastructure provisioning: Terraform manages the cluster lifecycle, Docker image builds, and Kubernetes resources instead of separate YAML files.
- No `kubectl apply -f`; everything is handled by Terraform.
- Automation via Terraform commands and scripts instead of Makefile targets.
- Single `terraform apply` deploys everything end-to-end.

## How to Use

1. Ensure Minikube, Docker, and Terraform are installed.
2. Navigate to `infra/` directory.
3. Run `terraform init`.
4. Run `terraform plan -var-file env.tfvars`.
5. Run `terraform apply -var-file env.tfvars`.
6. Update `/etc/hosts` with the cluster IP for `cstrader.local`.
7. Access the app at `https://cstrader.local`.

## How to destroy the environment

To tear down all resources:
1. In `infra/`, run `make clean`.

This will remove the cluster and all deployed resources.

## Known limitations

- Designed for local development with Minikube; not production-ready.
- Self-signed TLS certificates (ignore browser warnings).
- Single environment; scaling to multiple clients/environments would require further modularization.
- Docker builds are done locally; in CI/CD, use registries.