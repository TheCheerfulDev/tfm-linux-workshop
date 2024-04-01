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

variable "vnet_address_space" {
  description = "The address space for the VNet"
  type        = list(string)
  default     = ["10.42.0.0/16"]
}

variable "subnet_name" {
  description = "The name of the subnet to create"
  type        = string
  default     = "workshop-subnet"
}

variable "subnet_address_prefix" {
  description = "The address prefix for the subnet"
  type        = list(string)
  default     = ["10.42.0.0/24"]
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

variable "dns_zone_name" {
  description = "The name of the DNS zone to use"
  type        = string
  default     = "Change this when setting create_dns_entries to true"
}

variable "dns_zone_rg" {
  description = "The resource group in which the DNS zone is located"
  type        = string
  default     = "Change this when setting create_dns_entries to true"
}

variable "workshop_name" {
  description = "The name of the workshop, this will be used as a subdomain when making use of a dns zone"
  type        = string
  default     = "workshop"
}

variable "use_ssh_key" {
  description = "Whether to use SSH key for the VMs"
  type        = bool
  default     = false
}

variable "ssh_key_name" {
  description = "The name of the SSH key to use"
  type        = string
  default     = "Change this when setting use_ssh_key to true"
}

variable "ssh_key_rg" {
  description = "The resource group in which the SSH key is located"
  type        = string
  default     = "Change this when setting use_ssh_key to true"
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}
