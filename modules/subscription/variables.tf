
variable "subscription_id" {
  type = string
}

variable "location" {
  type = object({
    name  = string
    short = string
    mini  = string
  })
}

variable "workload" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "policies" {
  type = map(string)
  default = {
    # https://www.azadvertizer.net/azpolicyinitiativesadvertizer/1f3afdf9-d0c9-4c3d-847f-89da613e70a8.html
    "Azure Security Benchmark" = "1f3afdf9-d0c9-4c3d-847f-89da613e70a8"
    # https://www.azadvertizer.net/azpolicyinitiativesadvertizer/c3f5c4d9-9a1d-4a99-85c0-7f93e384d5c5.html
    "CIS Microsoft Azure Foundations Benchmark v1.4.0" = "c3f5c4d9-9a1d-4a99-85c0-7f93e384d5c5"
  }
}

variable "pricing_plans" {
  type = map(object({
    tier    = string
    subplan = string
  }))
  default = {
    VirtualMachines = {
      tier    = "Standard"
      subplan = "P2"
    }
  }
}
