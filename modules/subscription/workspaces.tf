
locals {
  solutions = {
    Security = {
      publisher = "Microsoft"
      product   = "OMSGallery/Security"
    }
    SecurityCenterFree = {
      publisher = "Microsoft"
      product   = "OMSGallery/SecurityCenterFree"
    }
  }
}

resource "azurerm_log_analytics_workspace" "defender" {
  name                = join("-", ["log", local.resource_cname])
  location            = var.location.name
  resource_group_name = azurerm_resource_group.defender.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_security_center_workspace" "defender" {
  scope        = "/subscriptions/${var.subscription_id}"
  workspace_id = azurerm_log_analytics_workspace.defender.id
}

resource "azurerm_log_analytics_solution" "defender" {
  for_each = local.solutions

  solution_name         = each.key
  location              = var.location.name
  resource_group_name   = azurerm_resource_group.defender.name
  workspace_resource_id = azurerm_log_analytics_workspace.defender.id
  workspace_name        = azurerm_log_analytics_workspace.defender.name

  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }

  tags = var.tags
}
