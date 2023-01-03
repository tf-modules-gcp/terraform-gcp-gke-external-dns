# Deploy External DNS in GKE

## Example configuration

Terraform code

Variable "environment_dir" should be pointed to the directory where the helm values files located

```bash
module "external_dns" {
  depends_on = [
    module.gke
  ]
  source  = "git::https://github.com/tf-modules-gcp/terraform-gcp-gke-external-dns.git//modules/external-dns?ref=0.1.0"
  environment_dir = var.environment_dir
  sa_sufix        = var.gke.cluster.name
  project_id      = var.gcp.project_id
  helm_config     = var.external_dns
}
```

```bash
module "external_dns" {
  depends_on = [
    module.gke
  ]
  source  = "git::https://github.com/tf-modules-gcp/terraform-gcp-gke-external-dns.git//modules/external-dns?ref=0.1.0"
  environment_dir = var.environment_dir
  sa_sufix        = var.gke.cluster.name
  project_id      = var.gcp.project_id
  helm_config     = {
    namespace = "external-dns"
    chart = {
      repository = "https://kubernetes-sigs.github.io/external-dns"
      version    = "1.12.0"
      values_files = [
        "helm_values_external_dns.yml"
      ]
    }
  }
}
```

Helm chart values file: helm_values_external_dns.yml

```yaml
serviceAccount:
  name: "external-dns"
provider: google
domainFilters:
- "example.com"
```
