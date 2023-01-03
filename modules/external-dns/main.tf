resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = var.helm_config.namespace
  }
}
resource "helm_release" "external_dns" {
  depends_on = [
    kubernetes_namespace.external_dns,
    google_project_iam_member.iam_member
  ]
  chart      = "external-dns"
  name       = "external-dns"
  namespace  = kubernetes_namespace.external_dns.metadata[0].name
  repository = var.helm_config.chart.repository
  version    = var.helm_config.chart.version
  timeout    = 600
  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = google_service_account.service_account.email
    type  = "string"
  }
  
  values = [for s in var.helm_config.chart.values_files : file("${local.environment_dir}/${s}")]
}
