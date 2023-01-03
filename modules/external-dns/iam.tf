resource "random_string" "external_dns_service_account_suffix" {
  upper   = false
  lower   = true
  special = false
  length  = 4
}
resource "google_service_account" "service_account" {
  project      = var.project_id
  account_id   = "tf-gke-${substr(var.sa_sufix, 0, min(15, length(var.sa_sufix)))}-${random_string.external_dns_service_account_suffix.result}"
  display_name = format("Service account for External DNS %s", var.sa_sufix)
  description  = format("Service account for External DNS %s", var.sa_sufix)
}

resource "google_project_iam_member" "iam_member" {
  depends_on = [google_service_account.service_account]
  project    = var.project_id
  role       = "roles/dns.admin"
  member     = "serviceAccount:${google_service_account.service_account.email}"
}

resource "google_service_account_iam_member" "workloadIdentityUser" {
  depends_on = [
    google_project_iam_member.iam_member,
    helm_release.external_dns
  ]
  service_account_id = google_service_account.service_account.name
  role               = "roles/iam.workloadIdentityUser"
  member             = format("serviceAccount:%s.svc.id.goog[%s/%s]", var.project_id, kubernetes_namespace.external_dns.id, lookup(lookup(yamldecode(helm_release.external_dns.values[0]), "serviceAccount", {}), "name", "external-dns"))
}
