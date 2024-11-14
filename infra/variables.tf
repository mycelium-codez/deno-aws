variable "environment" {
  type    = string
  default = "dev"
}

variable "git_sha" {
  type    = string
  description = "git sha for current deployment"
}