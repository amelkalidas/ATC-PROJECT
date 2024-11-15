resource "azurerm_resource_group" "atc-rg" {
  name     = "atc-step2-rg"
  location = "EastAsia"
}

resource "azurerm_kubernetes_cluster" "atc-kube-cluster" {
  name                = "atcstep2_cluster"
  location            = azurerm_resource_group.atc-rg.location
  resource_group_name = azurerm_resource_group.atc-rg.name
  dns_prefix          = "atcwebappcluster"
  kubernetes_version = data.azurerm_kubernetes_service_versions.current.latest_version
  node_resource_group = "atcstep2-webappcluster-nrg"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2as_v4"
    auto_scaling_enabled = true
    orchestrator_version = data.azurerm_kubernetes_service_versions.current.latest_version
    max_count = 1
    min_count = 1
    os_disk_size_gb = 30
    type = "VirtualMachineScaleSets"
    node_public_ip_enabled = true

  }

  identity {
    type = "SystemAssigned"
  }
  role_based_access_control_enabled = true

  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }
  tags = {
    Environment = "Production"
  }
}
resource "azurerm_container_registry" "atc-proj-acr" {
  name                = "atcprojwebappcontainerreg"
  resource_group_name = azurerm_resource_group.atc-rg.name
  location            = azurerm_resource_group.atc-rg.location
  sku                 = "Premium"
}

