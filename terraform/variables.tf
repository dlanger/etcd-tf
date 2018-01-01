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

variable "network_cidr" {
  type        = "string"
  description = "cidr of the private network that can access etcd"
}

variable "etcd_node_role_name" {
  type        = "string"
  description = "iam role name for the nodes to use - needs AmazonEC2ReadOnlyAccess (or similar) access"
}
