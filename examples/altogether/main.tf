
locals {
  location = {
    name  = "westeurope"
    short = "westeu"
    mini  = "weu"
  }
}

module "defender" {
  source = "../../"

  jit = {
    enabled = true
    subscription_id = var.subscription_id
  }

  subscription = {
    enabled = true
    subscription_id = var.subscription_id
  }

  location = local.location
  tags = {
    managed-by = "Terraform"
  }
}
