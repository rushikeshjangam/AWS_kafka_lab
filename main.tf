terraform {
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 4.0" }
  }
  required_version = ">= 1.5.0"
}

provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "eks_assume_role_policy" {
  statement {
    effect = "Allow"
    principals { type = "Service"; identifiers = ["eks.amazonaws.com"] }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    effect = "Allow"
    principals { type = "Service"; identifiers = ["ec2.amazonaws.com"] }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_cluster_role" {
  assume_role_policy = data.aws_iam_policy_document.eks_assume_role_policy.json

  import {
    to = aws_iam_role.eks_cluster_role
    id = "eks-cluster-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSClusterPolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cluster_AmazonEKSServicePolicy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role" "eks_node_role" {
  assume_role_policy = data.aws_iam_policy_document.eks_node_assume_role_policy.json

  import {
    to = aws_iam_role.eks_node_role
    id = "eks-node-group-role"
  }
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKSWorkerNodePolicy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEC2ContainerRegistryReadOnly" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_node_AmazonEKS_CNI_Policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# Continue with your VPC, Subnets, and EKS cluster configuration...
