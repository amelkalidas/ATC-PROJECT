data "azurerm_kubernetes_service_versions" "current" {
  location = "West Europe"
  include_preview = false

}
