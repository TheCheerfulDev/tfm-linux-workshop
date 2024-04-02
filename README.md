# tfm-linux-workshop

## Variable Reference

### Required variables

| Variable Name       | Description                                               | Type   |
|---------------------|-----------------------------------------------------------|--------|
| resource_group_name | The resource group in which the resources will be created | string |
| vm_count            | The number of VMs to create                               | number |
| environment         | The environment to deploy the resources to                | string |
| location            | The Azure region in which the resources will be created   | string |
| vm_password         | The password for the VMs                                  | string |

## Optional variables

| Variable Name         | Description                                                                              | Type                                                                    | Default Value                                              |
|-----------------------|------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|------------------------------------------------------------|
| vm_size               | The size of the VMs to create                                                            | string                                                                  | Standard_DS1_v2                                            |
| vm_username           | The username for the VMs                                                                 | string                                                                  | azureuser                                                  |
| vm_name_prefix        | The prefix to use for the VM names                                                       | string                                                                  | workshop-vm                                                |
| vnet_name             | The name of the VNet to create                                                           | string                                                                  | workshop-vnet                                              |
| vnet_address_space    | The address space for the VNet                                                           | list(string)                                                            | ["10.42.0.0/16"]                                           |
| subnet_name           | The name of the subnet to create                                                         | string                                                                  | workshop-subnet                                            |
| subnet_address_prefix | The address prefix for the subnet                                                        | list(string)                                                            | ["10.42.0.0/24"]                                           |
| nsg_rules             | A mapping of security rules to apply to the NSG                                          | list(object({ name = string, priority = number, port_range = string })) | [{ name = "allow_ssh", priority = 100, port_range = "22"}] |
| nic_name_prefix       | The prefix to use for the NIC names                                                      | string                                                                  | workshop-nic                                               |
| public_ip_name_prefix | The prefix to use for the public IP names                                                | string                                                                  | workshop-pip                                               |
| create_dns_entries    | Whether to create DNS entries for the VMs                                                | bool                                                                    | false                                                      |
| dns_zone_name         | The name of the DNS zone to use                                                          | string                                                                  | Change this when setting create_dns_entries to true        |
| dns_zone_rg           | The resource group in which the DNS zone is located                                      | string                                                                  | Change this when setting create_dns_entries to true        |
| workshop_name         | The name of the workshop, this will be used as a subdomain when making use of a dns zone | string                                                                  | workshop                                                   |
| use_ssh_key           | Whether to use SSH key for the VMs                                                       | bool                                                                    | false                                                      |
| ssh_key_name          | The name of the SSH key to use                                                           | string                                                                  | Change this when setting use_ssh_key to true               |
| ssh_key_rg            | The resource group in which the SSH key is located                                       | string                                                                  | Change this when setting use_ssh_key to true               |
| tags                  | A mapping of tags to assign to the resources                                             | map(string)                                                             | {}                                                         |
