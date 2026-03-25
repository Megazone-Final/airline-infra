locals {
  names = {
    subnet_group       = join("-", [var.project_name, "db", "subnet", "group"])
    cluster_identifier = join("-", ["rds", var.region_code, var.project_name, "mysql", "main"])
    primary_instance   = join("-", ["rds", var.region_code, var.project_name, "mysql", "main", "instance", "1"])
    reader_instance    = join("-", ["rds", var.region_code, var.project_name, "mysql", "main", "instance", "2"])
    proxy_name         = join("-", ["proxy", var.project_name, "aurora", "mysql"])
  }
}
