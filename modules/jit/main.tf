
locals {
  resource_cname      = join("-", [var.workload, "jit", var.location.short])
  api_connection_name = "ascassessment"
  trigger_name        = "When_an_Microsoft_Defender_for_Cloud_Recommendation_is_created_or_triggered"
}

resource "azurerm_resource_group" "jit" {
  name     = join("-", ["rg", local.resource_cname])
  location = var.location.name
  tags     = var.tags
}
