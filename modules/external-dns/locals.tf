locals {
  environment_dir                 = trimsuffix(var.environment_dir, "/")
  helm_values                     = yamlencode(file(format("%s/%s",local.environment_dir,var.helm_config.chart.values_file)))
  kubernetes_service_account_name = try(local.helm_values["serviceAccount"]["name"],"external-dns")
}