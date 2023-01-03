# Folder for helm values files
variable "environment_dir" {
  type = string
}
variable "sa_sufix" {
  type = string
  default = "external-dns"
}
variable "project_id" {
  type    = string
}
variable "helm_config" {
  type = object({
    namespace : string
    chart : object({
      repository : string,
      version : string
      values_files : list(string)
    })
  })
}