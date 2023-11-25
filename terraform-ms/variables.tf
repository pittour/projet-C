variable "user" {
  type = string
  default = "kebi"
}

variable "site" {
  type = string
  default = "drupal"
}

variable "db_pass" {
  type = string
  sensitive = true
}

variable "db_user" {
  type = string
  sensitive = true
}