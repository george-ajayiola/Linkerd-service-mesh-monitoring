resource "azurerm_kubernetes_cluster" "this" {
  name                      = "${var.env}-${var.aks_name}"
  location                  = azurerm_resource_group.this.location
  resource_group_name       = azurerm_resource_group.this.name
  dns_prefix                = "devaks1"
  kubernetes_version        = var.aks_version
  # automatic_channel_upgrade = "stable"
  private_cluster_enabled   = false
  node_resource_group       = "${var.resource_group_name}-${var.env}-${var.aks_name}"


  # For production change to "Standard" 
  sku_tier = "Free"

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
    # service_cidr = "10.0.4.0/24"
    # dns_service_ip = "10.0.4.10"
    # docker_bridge_cidr = "172.17.0.1/16"
  }

  default_node_pool {
    name                 = "newpool"
    vm_size              = "Standard_D2_v2"
    vnet_subnet_id       = azurerm_subnet.subnet1.id
    orchestrator_version = var.aks_version
    type                 = "VirtualMachineScaleSets"
    # enable_auto_scaling  = false
    node_count           = 2
    
  }

  identity {
    type         = "SystemAssigned"
  }

  tags = {
    env = var.env
  }


}