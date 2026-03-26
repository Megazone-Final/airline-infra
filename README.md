# airline-infra

현재 Terraform으로 생성되는 리소스만 정리합니다.

## 생성 리소스

### VPC

- VPC 1개
- Pod 네트워킹용 보조 IPv4 CIDR 연결 1개
- Internet Gateway 1개
- Regional NAT Gateway 1개
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
- 클러스터 공용 보안그룹 1개
- 노드 공용 보안그룹 1개
- 기본 Managed Node Group 2개
  - `2a`
  - `2c`
- EKS 관리형 애드온 5개
  - `coredns`
  - `eks-pod-identity-agent`
  - `kube-proxy`
  - `vpc-cni`
  - `aws-ebs-csi-driver`
- EKS access entry 기반 admin principal 연결 1개

### Pod 네트워킹

- `ENIConfig` 2개
  - `ap-northeast-2a`
  - `ap-northeast-2c`

### IAM

- EKS 클러스터 IAM Role 1개
- Managed Node Group IAM Role 2개
- `aws-node`용 IRSA Role 1개
- `ebs-csi-controller-sa`용 IRSA Role 1개
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
