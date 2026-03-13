# airline-infra

This repository manages shared infrastructure and deployment state for the airline bootcamp project.

Application code lives in sibling repositories:

- `../airline-backend`
- `../airline-front`

## Scope

This repository owns:

- Terraform for shared AWS infrastructure
- EKS platform resources and cluster-level Kubernetes objects
- ArgoCD applications and deployment manifests for backend services
- Shared runtime configuration such as namespaces, ingress, and policies

This repository does not own:

- Backend application source code or tests
- Frontend application source code or static asset builds
- Docker image build pipelines

## Environment Strategy

Because the project uses a single AWS account and a limited budget, the live cloud environment is modeled as a single shared `prod` runtime.

- Local development happens in the backend and frontend repositories
- AWS runs one shared production-like environment
- If short-lived integration verification is needed later, use a temporary sandbox namespace instead of a full extra environment

`namespace` separation is still useful for operational boundaries even when there is only one cluster. The cost comes from running duplicate workloads, not from the namespace object itself.

## Delivery Model

- Backend services: `airline-backend` builds images and pushes them to ECR
- Backend runtime state: `airline-infra` manages Kubernetes or ArgoCD deployment state for those images
- Frontend: `airline-front` builds static assets and deploys them to S3 and CloudFront
- Frontend AWS resources: if they are provisioned with Terraform, the infrastructure for them belongs here

## Repository Layout

```text
terraform/
  environments/
    prod/         # single live Terraform entrypoint
  global/         # shared/global AWS components
  modules/        # reusable Terraform modules

kubernetes/
  platform/       # namespaces, ingress controller, monitoring, platform add-ons
  services/       # backend service manifests when deployed to EKS
  shared/         # shared ingress, policy, quota, storage settings

argocd/           # ArgoCD apps and projects
docs/             # operating notes and architecture decisions
diagrams/         # architecture diagrams
scripts/          # helper scripts
```

## Working Rules

- Keep the Terraform root in `terraform/environments/prod`
- Compose the live environment from reusable modules in `terraform/modules`
- Enable expensive resources intentionally through `terraform/environments/prod/terraform.tfvars`
- Treat this repository as the source of truth for backend deployment state
- Keep frontend Kubernetes manifests out of production ownership unless the frontend is actually moved onto EKS
- Prefer one ALB or ingress entrypoint instead of separate public load balancers per service
