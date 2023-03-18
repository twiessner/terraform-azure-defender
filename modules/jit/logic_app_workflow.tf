
data "azurerm_managed_api" "ascassessment" {
  name     = local.api_connection_name
  location = var.location.name
}

resource "azurerm_api_connection" "api" {
  name                = local.api_connection_name
  display_name        = local.api_connection_name
  resource_group_name = azurerm_resource_group.jit.name
  managed_api_id      = data.azurerm_managed_api.ascassessment.id
}

resource "azurerm_logic_app_workflow" "jit" {
  name                = join("-", ["logic", local.resource_cname])
  location            = var.location.name
  resource_group_name = azurerm_resource_group.jit.name

  identity {
    type = "SystemAssigned"
  }

  enabled          = true
  workflow_version = "1.0.0.0"
  workflow_schema  = "https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#"

  parameters = {
    "$connections" = jsonencode(
      {
        ascassessment = {
          connectionId   = azurerm_api_connection.api.id
          connectionName = azurerm_api_connection.api.name
          id             = data.azurerm_managed_api.ascassessment.id
        }
      }
    )
  }

  workflow_parameters = {
    "$connections" = jsonencode(
      {
        defaultValue = {}
        type         = "Object"
      }
    )
  }
}
