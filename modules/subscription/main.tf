
locals {
  resource_cname = join("-", [var.workload, var.location.short])
}

resource "azurerm_resource_group" "defender" {
  name     = join("-", ["rg", local.resource_cname])
  location = var.location.name
  tags     = var.tags
}

resource "azurerm_security_center_auto_provisioning" "provisioning" {
  auto_provision = "On"
}
