locals {
  karpenter_ami_selector_terms = var.eks_karpenter_ami_id != null ? [
    {
      id = var.eks_karpenter_ami_id
    }
    ] : [
    {
      alias = var.eks_karpenter_ami_alias
    }
  ]
}

resource "kubernetes_namespace" "karpenter" {
  metadata {
    name = var.eks_karpenter_namespace
  }
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = kubernetes_namespace.karpenter.metadata[0].name
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.eks_karpenter_chart_version
  create_namespace = false
  wait             = false

  values = [
    yamlencode({
      dnsPolicy = "Default"
      replicas  = 1
      nodeSelector = {
        "karpenter.sh/controller" = "true"
      }
      serviceAccount = {
        create = true
        name   = var.eks_karpenter_service_account_name
      }
      settings = {
        clusterName       = var.cluster_name
        clusterEndpoint   = var.cluster_endpoint
        interruptionQueue = var.karpenter_interruption_queue_name
      }
      webhook = {
        enabled = false
      }
    })
  ]
}

resource "kubectl_manifest" "karpenter_ec2_node_class" {
  yaml_body = yamlencode({
    apiVersion = "karpenter.k8s.aws/v1"
    kind       = "EC2NodeClass"
    metadata = {
      name = var.karpenter_node_class_name
    }
    spec = {
      amiFamily = var.eks_karpenter_ami_family
      role      = var.karpenter_node_iam_role_name
      tags = merge(var.tags, {
        Name      = var.karpenter_node_name
        ManagedBy = "karpenter"
      })
      subnetSelectorTerms = [
        for subnet_id in var.node_subnet_ids : {
          id = subnet_id
        }
      ]
      securityGroupSelectorTerms = [
        {
          id = var.node_security_group_id
        }
      ]
      amiSelectorTerms = local.karpenter_ami_selector_terms
    }
  })

  depends_on = [helm_release.karpenter]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = yamlencode({
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name = var.karpenter_node_pool_name
    }
    spec = {
      template = {
        spec = {
          nodeClassRef = {
            group = "karpenter.k8s.aws"
            kind  = "EC2NodeClass"
            name  = var.karpenter_node_class_name
          }
          requirements = [
            {
              key      = "karpenter.sh/capacity-type"
              operator = "In"
              values   = var.eks_karpenter_capacity_types
            },
            {
              key      = "kubernetes.io/arch"
              operator = "In"
              values   = var.eks_karpenter_architectures
            },
            {
              key      = "karpenter.k8s.aws/instance-category"
              operator = "In"
              values   = var.eks_karpenter_instance_categories
            }
          ]
        }
      }
      disruption = {
        consolidationPolicy = var.eks_karpenter_consolidation_policy
        consolidateAfter    = var.eks_karpenter_consolidate_after
      }
    }
  })

  depends_on = [kubectl_manifest.karpenter_ec2_node_class]
}
