variable "resource_group_name" {
  description = "The resource group in which the resources will be created"
  type        = string
}

variable "vm_count" {
  description = "The number of VMs to create"
  type        = number
}

variable "environment" {
  description = "The environment to deploy the resources to"
  type        = string
}

variable "location" {
  description = "The Azure region in which the resources will be created"
  type        = string
}

variable "vm_size" {
  description = "The size of the VMs to create"
  type        = string
  default     = "Standard_DS1_v2"
}

variable "vm_username" {
  description = "The username for the VMs"
  type        = string
  default     = "azureuser"
}

variable "vm_password" {
  description = "The password for the VMs"
  type        = string
  sensitive   = true
}

variable "vm_name_prefix" {
  description = "The prefix to use for the VM names"
  type        = string
  default     = "workshop-vm"
}

variable "vnet_name" {
  description = "The name of the VNet to create"
  type        = string
  default     = "workshop-vnet"
}

variable "subnet_name" {
  description = "The name of the subnet to create"
  type        = string
  default     = "workshop-subnet"
}

variable "nic_name_prefix" {
  description = "The prefix to use for the NIC names"
  type        = string
  default     = "workshop-nic"
}

variable "public_ip_name_prefix" {
  description = "The prefix to use for the public IP names"
  type        = string
  default     = "workshop-pip"
}

variable "create_dns_entries" {
  description = "Whether to create DNS entries for the VMs"
  type        = bool
  default     = false
}