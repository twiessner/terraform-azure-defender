
variable "subscription_id" {
  type = string
}

variable "workload" {
  type = string
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
