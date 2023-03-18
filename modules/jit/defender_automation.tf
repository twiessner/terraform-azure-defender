
resource "azurerm_security_center_automation" "vm_jit_access" {
  name                = "vm_jit_access"
  location            = var.location.name
  resource_group_name = azurerm_resource_group.jit.name

  scopes = ["/subscriptions/${var.subscription_id}"]

  action {
    type        = "logicapp"
    resource_id = azurerm_logic_app_workflow.jit.id
    trigger_url = azurerm_logic_app_trigger_http_request.trigger.callback_url
  }

  source {
    event_source = "Assessments"

    rule_set {
      rule {
        property_path  = "properties.status.code"
        operator       = "Contains"
        expected_value = "unhealthy"
        property_type  = "String"
      }
      # https://www.azadvertizer.net/azpolicyadvertizer/b0f33259-77d7-4c9e-aac6-3aabcfae693c.html
      rule {
        property_path  = "name"
        operator       = "Equals"
        expected_value = "805651bc-6ecd-4c73-9b55-97a19d0582d0"
        property_type  = "String"
      }
    }
  }
}
