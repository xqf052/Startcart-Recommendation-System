variable "app_version" {
}

variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  #default     = "PROD"
}

variable "s3_bucket" {
    type = string
}