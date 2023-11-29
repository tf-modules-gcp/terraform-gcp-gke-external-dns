resource "random_string" "external_dns_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}
resource "google_service_account" "service_account" {
  project      = var.gke_project_id
  account_id   = "tf-gke-${substr(var.sa_sufix, 0, min(15, length(var.sa_sufix)))}-${random_string.external_dns_service_account_suffix.result}"
  display_name = format("Service account for External DNS %s", var.sa_sufix)
  description  = format("Service account for External DNS %s", var.sa_sufix)
}
resource "google_project_iam_member" "iam_member" {
  project = var.dns_project_id
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.service_account.email}"
}
resource "google_service_account_iam_member" "workloadIdentityUser" {
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member = format("serviceAccount:%s.svc.id.goog[%s/%s]",
    var.gke_project_id,
    kubernetes_namespace_v1.this.id,
    local.kubernetes_service_account_name
  )
}
