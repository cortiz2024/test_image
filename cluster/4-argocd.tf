data "azurerm_kubernetes_cluster" "this" {
  name                = azurerm_kubernetes_cluster.this.name
  resource_group_name = local.resource_group_name

  # Comment this out if you get: Error: Kubernetes cluster unreachable 
  depends_on = [azurerm_kubernetes_cluster.this]
}

provider "helm" {
  kubernetes {
    host                   = data.azurerm_kubernetes_cluster.this.kube_config.0.host
    client_certificate     = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_certificate)
    client_key             = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(data.azurerm_kubernetes_cluster.this.kube_config.0.cluster_ca_certificate)
  }
}

resource "helm_release" "argocd" {
  name       = local.namespace
  chart      = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  version    = "5.27.3"
  namespace  = local.namespace
  create_namespace = true 
  timeout    = "1200"
  values     = [templatefile("./argocd/argocd_values.yaml", {})]

  depends_on = [ data.azurerm_kubernetes_cluster.this ]
}