variable "vpc_id" {
  type = "string"
}

variable "subnet_ids" {
  type = "list"
}

variable "cluster_size" {
  type        = "string"
  description = "number of nodes in cluster; defaults to one per subnet_id"
  default     = ""
}

variable "tag_name" {
  type        = "string"
  description = "name of the tag which will be applied to all resources created"
  default     = "service"
}

variable "ami" {
  type        = "string"
  description = "coreos ami to use"
}

variable "key_name" {
  type        = "string"
  description = "aws key name to bake into nodes"
}

variable "instance_type" {
  type    = "string"
  default = "m3.medium"
}
