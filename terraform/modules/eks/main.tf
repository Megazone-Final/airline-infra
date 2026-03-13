resource "aws_cloudwatch_log_group" "this" {
  count = var.enabled && length(var.cluster_log_types) > 0 ? 1 : 0

  name              = "/aws/eks/${var.name}/cluster"
  retention_in_days = var.cloudwatch_log_retention_in_days

  tags = merge(var.tags, {
    Name = "${var.name}-eks-logs"
  })
}

resource "aws_iam_role" "cluster" {
  count = var.enabled ? 1 : 0

  name = "${var.name}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_eks_cluster_policy" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.cluster[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "cluster_vpc_resource_controller" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.cluster[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

resource "aws_iam_role" "node" {
  count = var.enabled ? 1 : 0

  name = "${var.name}-${var.node_group_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "node_eks_worker" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.node[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "node_cni" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.node[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "node_ecr_read_only" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.node[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_security_group" "cluster" {
  count = var.enabled ? 1 : 0

  name        = "${var.name}-eks-cluster"
  description = "Cluster security group for ${var.name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.name}-eks-cluster"
  })
}

resource "aws_eks_cluster" "this" {
  count = var.enabled ? 1 : 0

  name     = var.name
  role_arn = aws_iam_role.cluster[0].arn
  version  = var.cluster_version

  enabled_cluster_log_types = var.cluster_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.endpoint_public_access_cidrs
    security_group_ids      = [aws_security_group.cluster[0].id]
  }

  kubernetes_network_config {
    service_ipv4_cidr = var.kubernetes_service_ipv4_cidr
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_eks_cluster_policy,
    aws_iam_role_policy_attachment.cluster_vpc_resource_controller,
    aws_cloudwatch_log_group.this,
  ]

  tags = var.tags
}

resource "aws_eks_node_group" "this" {
  count = var.enabled ? 1 : 0

  cluster_name    = aws_eks_cluster.this[0].name
  node_group_name = "${var.name}-${var.node_group_name}"
  node_role_arn   = aws_iam_role.node[0].arn
  subnet_ids      = var.subnet_ids
  instance_types  = var.node_group_instance_types
  capacity_type   = var.node_group_capacity_type
  disk_size       = var.node_group_disk_size

  scaling_config {
    desired_size = var.node_group_desired_size
    min_size     = var.node_group_min_size
    max_size     = var.node_group_max_size
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_eks_worker,
    aws_iam_role_policy_attachment.node_cni,
    aws_iam_role_policy_attachment.node_ecr_read_only,
  ]

  tags = var.tags
}
