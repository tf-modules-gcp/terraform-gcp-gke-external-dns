# Deploy External DNS in GKE

## Example configuration

Terraform code

Variable "environment_dir" should be pointed to the directory where the helm values files located

```bash
module "external_dns" {
  depends_on = [
    module.gke
  ]
  source  = "git::https://github.com/tf-modules-gcp/terraform-gcp-gke-external-dns.git//modules/external-dns?ref=0.0.1"
  environment_dir = var.environment_dir
  sa_sufix        = var.gke.cluster.name
  gke_project_id  = var.gcp.gke_project_id
  dns_project_id  = var.gcp.dns_project_id
  helm_config     = {
    namespace = "external-dns"
    chart = {
      repository   = "https://kubernetes-sigs.github.io/external-dns"
      version      = "1.13.1"
      values_files = "helm_values_external_dns.yml"
    }
  }
}
```

Helm chart values file: helm_values_external_dns.yml

```yaml
extraArgs:
- --google-project={{ dns_project_id }}
provider: google
domainFilters:
- "{{ dns_zone }}"
tolerations: "{{ default_tolerations }}"
nodeSelector:
  kubernetes.io/arch: arm64
```
