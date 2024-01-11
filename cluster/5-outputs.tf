output "aks-get-kube-config-login-command" {
  value = "az aks get-credentials --resource-group ${local.resource_group_name} --name ${azurerm_kubernetes_cluster.this.name}"
}

output "argocd_get_password" {
  value = "kubectl -n ${local.namespace} get secret argocd-initial-admin-secret -o jsonpath={.data.password} | base64 -d > ./argocd/argocd-login.txt"
}