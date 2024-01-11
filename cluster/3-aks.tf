data "azurerm_resource_group" "this" {
  name = local.resource_group_name
}

resource "azurerm_kubernetes_cluster" "this" {
  name                = "${local.aks_name}-${local.env}"
  location            = local.region
  resource_group_name = local.resource_group_name
  dns_prefix          = "monitoringaks"

  kubernetes_version        = local.aks_version
  automatic_channel_upgrade = "stable"
  private_cluster_enabled   = false
  node_resource_group       = "${local.resource_group_name}-${local.env}-${local.aks_name}"

  sku_tier = "Free"

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  network_profile {
    network_plugin = "azure"
    dns_service_ip = "10.0.64.10"
    service_cidr   = "10.0.64.0/19"
  }

  default_node_pool {
    name                 = "general"
    vm_size              = "Standard_B2s"
    vnet_subnet_id       = azurerm_subnet.subnet1.id
    orchestrator_version = local.aks_version
    node_count           = 2

    node_labels = {
      role = "general"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    env = local.env
  }

  lifecycle {
    ignore_changes = [default_node_pool[0].node_count]
  }
}