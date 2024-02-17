variable "table_name" {
  description = "Name of the dynamoDB table"
  type        = string
}

variable "hash_key" {
  description = "Hash key"
  type        = string
}

variable "range_key" {
  description = "Range key"
  type        = string
}

variable "hash_key_type" {
  description = "Hash key type"
  type        = string
}

variable "range_key_type" {
  description = "Range key type"
  type        = string
}

variable "autoscale_max_capacity" {
  description = "Autoscale maximum capacity"
  type        = string
}

variable "autoscale_min_capacity" {
  description = "Autoscale minimum capacity"
  type        = string
}