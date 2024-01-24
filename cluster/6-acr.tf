resource "azurerm_container_registry" "acr" {
  name                = "${local.aks_name}${local.env}acr1"
  resource_group_name = local.resource_group_name
  location            = local.region
  sku                 = "Standard"
}