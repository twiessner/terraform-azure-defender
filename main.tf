
module "jit" {
  count  = var.jit.enabled ? 1 : 0
  source = "./modules/jit"

  location        = var.location
  subscription_id = var.jit.subscription_id
  workload        = var.workload
  tags            = var.tags
}

module "subscription" {
  count  = var.subscription.enabled ? 1 : 0
  source = "./modules/subscription"

  location        = var.location
  subscription_id = var.subscription.subscription_id
  workload        = var.workload
  tags            = var.tags
}
