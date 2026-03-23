resource "kubectl_manifest" "storage_class_gp3" {
  yaml_body = file("${path.module}/manifests/storageclass-gp3.yaml")
}
