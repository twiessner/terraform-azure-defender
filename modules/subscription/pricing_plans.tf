
resource "azurerm_security_center_subscription_pricing" "pricing" {
  for_each = var.pricing_plans

  resource_type = each.key
  tier          = each.value.tier
  subplan       = each.value.subplan
}
