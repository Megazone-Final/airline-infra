resource "kubectl_manifest" "eni_config" {
  for_each = local.pod_eni_configs

  yaml_body = yamlencode({
    apiVersion = "crd.k8s.amazonaws.com/v1alpha1"
    kind       = "ENIConfig"
    metadata = {
      name = each.key
    }
    spec = {
      securityGroups = [module.cluster.node_security_group_id]
      subnet         = each.value
    }
  })

  depends_on = [
    time_sleep.cluster_admin_access_ready,
  ]
}
