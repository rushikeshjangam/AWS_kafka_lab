variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of EC2 Key Pair (must exist in AWS)"
  type        = string
  default     = "eks-kafka"
}

variable "use_import_blocks" {
  description = "When true, enable Terraform import blocks for existing IAM roles"
  type        = bool
  default     = true
}
