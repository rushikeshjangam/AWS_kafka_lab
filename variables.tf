variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Name of EC2 Key Pair"
  type        = string
  default     = "eks-kafka"
}
