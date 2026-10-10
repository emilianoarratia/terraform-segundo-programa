provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  # Microsoft.Network se verifica y registra explícitamente con Azure CLI.
  resource_provider_registrations = "none"
}
