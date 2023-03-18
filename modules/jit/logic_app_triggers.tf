
resource "azurerm_logic_app_trigger_http_request" "trigger" {
  name         = local.trigger_name
  logic_app_id = azurerm_logic_app_workflow.jit.id
  method       = "POST"

  schema = <<BODY
{
  "inputs": {
    "body": {
      "callback_url": "@{listCallbackUrl()}"
    },
    "host": {
      "connection": {
        "name": "@parameters('$connections')['ascassessment']['connectionId']"
      }
    },
    "path": "/Microsoft.Security/Assessment/subscribe"
  },
  "type": "ApiConnectionWebhook"
}
BODY
}