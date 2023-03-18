
variable "jit" {
  type = object({
    enabled         = bool
    subscription_id = string
  })
}

variable "subscription" {
  type = object({
    enabled         = bool
    subscription_id = string
  })
}

variable "workload" {
  type    = string
  default = "defender-for-cloud"
}

variable "location" {
  type = object({
    name  = string
    short = string
    mini  = string
  })
}

variable "tags" {
  type = map(string)
}
