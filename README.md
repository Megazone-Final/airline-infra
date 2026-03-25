# airline-infra

운영 AWS 인프라 Terraform 저장소.

- VPC
- EKS
- Pod 서브넷 기반 Pod IP 할당
- Karpenter
- Private 워크스테이션 EC2 기반 EKS 접근

현재 기준 루트:

- `terraform/environments/prod-vpc`
- `terraform/environments/prod-eks`

상태 파일:

- Terraform state는 원격 S3 backend로 관리합니다.

## 생성 리소스

### VPC

- VPC 1개
- Pod 네트워킹용 보조 IPv4 CIDR 연결 1개
- Internet Gateway 1개
- NAT Gateway 1개
- 서브넷 8개
  - Public 2개
  - Node Private 2개
  - DB Private 2개
  - Pod Private 2개
- 라우트 테이블 4개
  - `public`
  - `private`
  - `db_private`
  - `pod_private`
- 라우트 테이블 연결 8개

### EKS

- EKS 클러스터 1개
- Control Plane 로그용 CloudWatch Log Group 1개
- OIDC Provider 1개
- API endpoint는 private only
- 클러스터 공용 보안그룹 1개
- 노드 공용 보안그룹 1개
- 기본 Managed Node Group 1개
- EKS 관리형 애드온 5개
  - `coredns`
  - `eks-pod-identity-agent`
  - `kube-proxy`
  - `vpc-cni`
  - `aws-ebs-csi-driver`

### Pod 네트워킹

- `ENIConfig` 2개
  - `ap-northeast-2a`
  - `ap-northeast-2c`
- Pod는 노드 위에서 실행되고, Pod IP는 Pod Private 서브넷 대역에서 할당됨

### IAM

- EKS 클러스터 IAM Role 1개
- Managed Node Group IAM Role 1개
- `aws-node`용 IRSA Role 1개
- `ebs-csi-controller-sa`용 IRSA Role 1개
- 워크스테이션 EC2용 EKS Admin IAM Role 1개
- 워크스테이션 EC2용 Instance Profile 1개
- Karpenter Controller IAM Role 1개
- Karpenter Node IAM Role 1개
- Karpenter Node Instance Profile 1개

### Karpenter

- 중단 이벤트 처리용 SQS Queue 1개
- EventBridge Rule 및 Target
- `karpenter` 네임스페이스 1개
- Karpenter Helm Release 1개
- `EC2NodeClass` 1개
- `NodePool` 1개

## 기본값

- 리전: `ap-northeast-2`
- 기본 VPC CIDR: `10.0.0.0/24`
- Pod 보조 CIDR: `100.64.0.0/23`
- Kubernetes 버전: `1.35`
- 기본 노드 그룹 인스턴스 타입: `t3.medium`

## 주요 디렉터리

- `terraform/environments/prod-vpc`: VPC 전용 루트
- `terraform/environments/prod-eks`: EKS 전용 루트
- `terraform/modules/vpc`: VPC 모듈
- `terraform/modules/eks`: EKS 모듈
