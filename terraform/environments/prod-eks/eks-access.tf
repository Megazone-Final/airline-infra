locals {
  workstation_eks_admin_role_name             = join("-", ["iam", var.region_code, var.project_name, "workstation", "eks-admin"])
  workstation_eks_admin_instance_profile_name = join("-", ["profile", var.region_code, var.project_name, "workstation", "eks-admin"])
}

data "aws_iam_policy_document" "workstation_eks_admin_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "workstation_eks_admin_inline" {
  statement {
    sid = "EksDescribeCluster"

    actions = ["eks:DescribeCluster"]

    resources = [
      "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${data.terraform_remote_state.network.outputs.eks_cluster_name}"
    ]
  }

  statement {
    sid = "EksListClusters"

    actions = ["eks:ListClusters"]

    resources = ["*"]
  }
}

resource "aws_iam_role" "workstation_eks_admin" {
  name               = local.workstation_eks_admin_role_name
  assume_role_policy = data.aws_iam_policy_document.workstation_eks_admin_assume_role.json

  tags = merge(local.common_tags, {
    Name = local.workstation_eks_admin_role_name
  })
}

resource "aws_iam_role_policy" "workstation_eks_admin" {
  name   = "${local.workstation_eks_admin_role_name}-inline"
  role   = aws_iam_role.workstation_eks_admin.id
  policy = data.aws_iam_policy_document.workstation_eks_admin_inline.json
}

resource "aws_iam_role_policy_attachment" "workstation_ssm_core" {
  role       = aws_iam_role.workstation_eks_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "workstation_eks_admin" {
  name = local.workstation_eks_admin_instance_profile_name
  role = aws_iam_role.workstation_eks_admin.name

  tags = merge(local.common_tags, {
    Name = local.workstation_eks_admin_instance_profile_name
  })
}
