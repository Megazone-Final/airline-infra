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

  depends_on = [
    module.cluster,
    time_sleep.cluster_admin_access_ready,
  ]
}

resource "helm_release" "karpenter" {
  name             = "karpenter"
  namespace        = kubernetes_namespace.karpenter.metadata[0].name
  repository       = "oci://public.ecr.aws/karpenter"
  chart            = "karpenter"
  version          = var.eks_karpenter_chart_version
  create_namespace = false
  wait             = true
  timeout          = 600

  values = [
    yamlencode({
      dnsPolicy = "Default"
      replicas  = 2
      nodeSelector = {
        "karpenter.sh/controller" = "true"
      }
      serviceAccount = {
        create = true
        name   = var.eks_karpenter_service_account_name
      }
      settings = {
        clusterName       = module.cluster.cluster_name
        clusterEndpoint   = module.cluster.cluster_endpoint
        interruptionQueue = module.karpenter.queue_name
        reservedENIs      = "1"
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
      name = local.names.karpenter_node_class
    }
    spec = {
      amiFamily = var.eks_karpenter_ami_family
      role      = module.karpenter.node_iam_role_name
      tags = merge(var.tags, {
        Name      = local.names.karpenter_node_name
        ManagedBy = "karpenter"
      })
      subnetSelectorTerms = [
        for subnet_id in local.node_subnet_ids : {
          id = subnet_id
        }
      ]
      securityGroupSelectorTerms = [
        {
          id = module.cluster.node_security_group_id
        }
      ]
      amiSelectorTerms = local.karpenter_ami_selector_terms
    }
  })

  depends_on = [
    helm_release.karpenter,
    time_sleep.cluster_admin_access_ready,
  ]
}

resource "kubectl_manifest" "karpenter_node_pool" {
  yaml_body = yamlencode({
    apiVersion = "karpenter.sh/v1"
    kind       = "NodePool"
    metadata = {
      name = local.names.karpenter_node_pool
    }
    spec = {
      template = {
        spec = {
          nodeClassRef = {
            group = "karpenter.k8s.aws"
            kind  = "EC2NodeClass"
            name  = local.names.karpenter_node_class
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

  depends_on = [
    kubectl_manifest.karpenter_ec2_node_class,
    time_sleep.cluster_admin_access_ready,
  ]
}
