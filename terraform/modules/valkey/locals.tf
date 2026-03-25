locals {
  names = {
    # Common Subnet
    subnet_group = join("-", ["valkey", var.region_code, var.project_name, "subnet", "gr"])

    # 1. Session Cache
    session_cluster = join("-", ["valkey", var.region_code, var.project_name, "session"])
    session_ug      = join("-", ["valkey", var.project_name, "session", "gr"])
    session_user    = "valkey-user"

    # 2. Backend SVC Cache
    svc_cluster      = join("-", ["valkey", var.region_code, var.project_name, "svc"])
    svc_ug           = join("-", ["valkey", var.project_name, "svc", "gr"])
    svc_user_auth    = "auth-user"
    svc_user_flight  = "flight-user"
    svc_user_payment = "payment-user"
  }
}
