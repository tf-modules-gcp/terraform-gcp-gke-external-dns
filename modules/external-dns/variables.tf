# Folder for helm values files
variable "environment_dir" {
  type = string
}
variable "sa_sufix" {
  type    = string
  default = "external-dns"
}
variable "gke_project_id" {
  type = string
}
variable "dns_project_id" {
  type    = string
  default = null
}
variable "helm_config" {
  type = object({
    namespace : string
    chart : object({
      repository : string,
      version : string
      values_file : string
    })
  })
}