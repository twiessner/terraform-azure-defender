
resource "azurerm_logic_app_action_custom" "vm_get_details" {
  name         = "Get_VM_Details"
  logic_app_id = azurerm_logic_app_workflow.jit.id

  body = <<BODY
{
  "inputs": {
    "authentication": {
      "type": "ManagedServiceIdentity"
    },
    "method": "GET",
    "uri": "https://management.azure.com/subscriptions/@{first(skip(split(triggerBody()?['properties']?['resourceDetails']?['id'], '/'), 2))}/resourceGroups/@{first(skip(split(triggerBody()?['properties']?['resourceDetails']?['id'], '/'), 4))}/providers/Microsoft.Compute/virtualMachines/@{first(skip(split(triggerBody()?['properties']?['resourceDetails']?['id'], '/'), 8))}?api-version=2019-07-01"
  },
  "runAfter": {},
  "type": "Http"
}
BODY
}

resource "azurerm_logic_app_action_custom" "vm_parse_schema" {
  name         = "Parse_VM_Schema"
  logic_app_id = azurerm_logic_app_workflow.jit.id

  body = <<BODY
{
  "inputs": {
    "content": "@body('Get_VM_Details')",
    "schema": {
      "$schema": "http://json-schema.org/draft-04/schema#",
      "properties": {
        "id": {
          "type": "string"
        },
        "location": {
          "type": "string"
        },
        "name": {
          "type": "string"
        }
      },
      "required": [
        "id",
        "name",
        "location"
      ],
      "type": "object"
    }
  },
  "runAfter": {
    "Get_VM_Details": [
      "Succeeded"
    ]
  },
  "type": "ParseJson"
}
BODY

  depends_on = [
    azurerm_logic_app_action_custom.vm_get_details
  ]
}

resource "azurerm_logic_app_action_custom" "vm_config_jit" {
  name         = "Set_VM_JIT_Config"
  logic_app_id = azurerm_logic_app_workflow.jit.id

  body = <<BODY
{
  "inputs": {
    "authentication": {
      "type": "ManagedServiceIdentity"
    },
    "body": {
      "kind": "Basic",
      "properties": {
        "virtualMachines": [
          {
            "id": "@{triggerBody()?['properties']?['resourceDetails']?['id']}",
            "ports": [
              {
                "allowedSourceAddressPrefix": "*",
                "maxRequestAccessDuration": "PT3H",
                "number": 22,
                "protocol": "*"
              },
              {
                "allowedSourceAddressPrefix": "*",
                "maxRequestAccessDuration": "PT3H",
                "number": 3389,
                "protocol": "*"
              }
            ]
          }
        ]
      }
    },
    "method": "PUT",
    "uri": "https://management.azure.com/subscriptions/@{first(skip(split(triggerBody()?['properties']?['resourceDetails']?['id'], '/'), 2))}/resourceGroups/@{first(skip(split(triggerBody()?['properties']?['resourceDetails']?['id'], '/'), 4))}/providers/Microsoft.Security/locations/@{body('Parse_VM_Schema')['location']}/jitNetworkAccessPolicies/@{first(skip(split(triggerBody()?['properties']?['resourceDetails']?['id'], '/'), 8))}JITPolicy?api-version=2015-06-01-preview"
  },
  "runAfter": {
    "Parse_VM_Schema": [
      "Succeeded"
    ]
  },
  "type": "Http"
}
BODY

  depends_on = [
    azurerm_logic_app_action_custom.vm_parse_schema
  ]
}