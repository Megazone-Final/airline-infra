output "eni_config_names" {
  description = "ENIConfig names created for pod networking."
  value       = sort(keys(var.pod_eni_configs))
}

output "karpenter_namespace" {
  description = "Namespace where Karpenter is deployed."
  value       = kubernetes_namespace.karpenter.metadata[0].name
}

output "karpenter_node_class_name" {
  description = "Default EC2NodeClass name for Karpenter."
  value       = var.karpenter_node_class_name
}

output "karpenter_node_pool_name" {
  description = "Default NodePool name for Karpenter."
  value       = var.karpenter_node_pool_name
}
