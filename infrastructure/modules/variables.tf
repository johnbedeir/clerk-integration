##############################################################
# VARIABLES
##############################################################

variable "clerk_public_key" {}
variable "clerk_private_key" {}
variable "clerk_api_url" {}

variable "ecr_name" {
  type    = string
  default = "clerk-app"
}

variable "name_prefix" {
  type        = string
  default     = "cluster-1"
  description = "Prefix to be used on each infrastructure object Name created in AWS."
}

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "environment" {
  type    = string
}

variable "min_number_of_nodes" {
  type        = number
  default     = 1
  description = "Minimum number of nodes"
}

variable "max_number_of_nodes" {
  type        = number
  default     = 3
  description = "Maximum number of nodes"
}

variable "desired_number_of_nodes" {
  type        = number
  default     = 2
  description = "Desired number of nodes"
}

variable "admin_users" {
  type        = list(string)
  default     = ["triple-a"]
  description = "List of Kubernetes admins."
}

variable "developer_users" {
  type        = list(string)
  default     = []
  description = "List of Kubernetes developers."
}

variable "main_network_block" {
  type        = string
  description = "Base CIDR block to be used in our VPC."
}

variable "private_subnets" {
  type        = list(string)
  description = "private_subnets"
}

variable "public_subnets" {
  type        = list(string)
  description = "public_subnets"
}

variable "subnet_prefix_extension" {
  type        = number
  default     = 4
  description = "CIDR block bits extension to calculate CIDR blocks of each subnetwork."
}

variable "zone_offset" {
  type        = number
  default     = 8
  description = "CIDR block bits extension offset to calculate Public subnets, avoiding collisions with Private subnets."
}

variable "asg_sys_instance_types" {
  type        = list(string)
  default     = ["t3a.medium"]
  description = "List of EC2 instance machine types to be used in EKS for the system workload."
}

variable "asg_dev_instance_types" {
  type        = list(string)
  default     = ["t3a.small"]
  description = "List of EC2 instance machine types to be used in EKS for development workload."
}

variable "asg_test_instance_types" {
  type        = list(string)
  default     = ["t3a.nano"]
  description = "List of EC2 instance machine types to be used in EKS for development workload."
}

variable "autoscaling_minimum_size_by_az" {
  type        = number
  default     = 1
  description = "Minimum number of EC2 instances to auto-scale our EKS cluster on each AZ."
}

variable "autoscaling_maximum_size_by_az" {
  type        = number
  default     = 2
  description = "Maximum number of EC2 instances to auto-scale our EKS cluster on each AZ."
}

variable "autoscaling_average_cpu" {
  type        = number
  default     = 60
  description = "Average CPU threshold to auto-scale EKS EC2 instances."
}