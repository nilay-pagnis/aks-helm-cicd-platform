variable "subscription_id" {
  type = string
}

variable "location" {
  type    = string
  default = "centralindia"
}

variable "prefix" {
  type    = string
  default = "taskapi"
}

variable "node_vm_size" {
  type    = string
  default = "Standard_D2as_v5"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "github_owner" {
  type    = string
  default = "nilay-pagnis"
}

variable "github_repo" {
  type    = string
  default = "aks-helm-cicd-platform"
}
