# prod

This directory is the Terraform entrypoint for the single shared AWS environment used by the project.

Use this folder to compose reusable modules from `../../modules` into the live runtime.

By default, expensive components are disabled. Turn them on intentionally in `terraform.tfvars` once you are ready to import or create them.

Recommended ownership:

- shared networking and IAM needed by the project
- ECR, EKS, and supporting platform resources
- frontend hosting resources such as S3 and CloudFront when they are managed with Terraform

Do not create parallel `dev` or `stage` stacks unless the project budget and operational model actually require them.
