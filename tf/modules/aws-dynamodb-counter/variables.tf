variable "table_name" {
  description = "Name of the dynamoDB table"
  type = string
}

variable "hash_key" {
    description = "Hash key"
    type = string
}

variable "range_key" {
    description = "Range key"
    type = string
    default = ""
}

variable "hash_key_type" {
    description = "Hash key type"
    type = string
}

variable "range_key_type" {
    description = "Range key type"
    type = string
    default = ""
}

variable "autoscale_max_capacity" {
    description = "Autoscale maximum capacity"
    type = number
}

variable "autoscale_min_capacity" {
    description = "Autoscale minimum capacity"
    type = number
}

variable "target_utilization" {
    description = "The target utilization percentage"
    type = number
}

variable "read_capacity" {
  description = "read capacity of the table"
  default = 1
  type = number
}

variable "write_capacity" {
  description = "write capacity of the table"
  default = 1
  type = number
}