variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of existing EC2 key pair"
  type        = string
  default     = "eks-kafka"
}

variable "use_import_blocks" {
  description = "If true, import existing IAM roles instead of creating new ones"
  type        = bool
  default     = true
}
