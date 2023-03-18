
resource "azurerm_subscription_policy_assignment" "policy" {
  for_each = var.policies

  name                 = each.key
  display_name         = each.key
  policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/${each.value}"
  subscription_id      = "/subscriptions/${var.subscription_id}"
}
