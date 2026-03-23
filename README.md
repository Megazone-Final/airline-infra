# airline-infra

`airline-infra`는 항공 프로젝트에서 사용하는 공용 AWS 인프라를 Terraform으로 관리하기 위한 저장소입니다. 현재는 Terraform 중심으로 구성되어 있으며, ArgoCD/문서/다이어그램/스크립트용 디렉터리는 대부분 플레이스홀더 상태입니다.

## 범위

이 저장소는 애플리케이션 코드가 아니라 인프라 리소스 관리를 담당합니다.

현재 `terraform/environments/prod`에서 실제로 활성화된 범위는 다음에 가깝습니다.

- VPC
- ECR
- WAF

EKS, IAM, RDS, S3, CloudWatch, Security Group 등은 일부 예시 파일 또는 자리만 마련된 상태입니다.

## 디렉터리 구조

### `terraform/environments/prod/`

공용 운영 환경의 Terraform 진입점입니다.

주요 파일:

- `vpc.tf` : 실제 VPC 모듈 호출
- `ecr.tf` : 실제 ECR 모듈 호출
- `waf.tf` : CloudFront 범위 WAF 모듈 호출
- `main.tf` : 비활성화된 참고용 파일
- `terraform.tfvars.example` : 예시 변수 파일
- `*.tf.example` : 향후 확장을 위한 예시 파일

### `terraform/modules/`

재사용 가능한 Terraform 모듈:

- `vpc/`
- `ecr/`
- `eks/`
- `s3/`
- `waf/`

현재 플레이스홀더에 가까운 모듈 디렉터리:

- `acm/`
- `cloudwatch/`
- `iam/`
- `rds/`
- `route53/`
- `security-group/`

### 기타 상위 디렉터리

- `argocd/` : 플레이스홀더
- `diagrams/` : 플레이스홀더
- `docs/` : 플레이스홀더
- `scripts/` : 플레이스홀더

## CI/CD

GitHub Actions 워크플로:

- `.github/workflows/terraform.yml`

현재 동작:

1. AWS 자격 증명 설정
2. `terraform fmt -check`
3. `terraform init`
4. `terraform validate`
5. Pull Request에서 `terraform plan`
6. Plan 결과를 PR 코멘트로 작성

중요:

- 현재 워크플로에서 `terraform apply`는 의도적으로 비활성화되어 있습니다.

## 로컬 사용

기본 명령:

```bash
cd terraform/environments/prod
terraform init
terraform validate
terraform plan
```

포맷 명령:

```bash
terraform fmt -recursive terraform
```

## 활성 파일과 참고 파일 구분

현재 활성 파일:

- `terraform/environments/prod/vpc.tf`
- `terraform/environments/prod/ecr.tf`
- `terraform/environments/prod/waf.tf`

참고용 예시 파일:

- `eks.tf.example`
- `iam.tf.example`
- `rds.tf.example`
- `s3.tf.example`
- `cloudwatch.tf.example`
- `security-group.tf.example`
- `waf.tf.example`

## 참고 사항

- `terraform/environments/prod/README.md`에 prod 진입점 설명이 추가로 있습니다.
- `prod/main.tf`는 현재 비활성화된 참고 파일입니다.
- 역할 구분은 아래처럼 유지하는 것이 맞습니다:
- 인프라는 이 저장소에서 관리
- EKS 매니페스트는 `../airline-eks`
- 애플리케이션 코드는 `../airline-front`, `../airline-backend`
