resource "kubernetes_namespace_v1" "this" {
  metadata {
    name = var.helm_config.namespace
  }
}
resource "kubernetes_service_account_v1" "this" {
  metadata {
    name      = local.kubernetes_service_account_name
    namespace = kubernetes_namespace_v1.this.metadata[0].name
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.service_account.email
    }
  }
}
resource "helm_release" "this" {
  depends_on = [
    kubernetes_namespace_v1.this,
    google_project_iam_member.iam_member,
    google_service_account_iam_member.workloadIdentityUser
  ]
  chart      = "external-dns"
  name       = "external-dns"
  namespace  = kubernetes_namespace_v1.this.metadata[0].name
  repository = var.helm_config.chart.repository
  version    = var.helm_config.chart.version
  timeout    = 600
  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account_v1.this.metadata[0].name
    type  = "string"
  }
  values = [file(format("%s/%s",local.environment_dir,var.helm_config.chart.values_file))]
}