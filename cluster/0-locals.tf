variable "env" {}

variable "region" {}

variable "resource_group_name" {}

variable "aks_name" {}

variable "aks_version" {}

variable "namespace" {}

locals {
  env                 = var.env
  region              = var.region
  resource_group_name = var.resource_group_name
  aks_name            = var.aks_name
  aks_version         = var.aks_version
  namespace           = var.namespace
}
