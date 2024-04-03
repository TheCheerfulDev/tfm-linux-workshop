# tfm-linux-workshop

## Example Use

The following example creates 2 VMs in resource group `bash-workshop-rg` located in the `West Europe` region with the
password `P@ssw0rd1234`. By default, SSH access is allowed on port 22, but no public key is provisioned.

```hcl
module "tmf-linux_workshop" {
  source = "git::https://github.com/TheCheerfulDev/tfm-linux-workshop"

  resource_group_name = "linux-workshop-rg"
  vm_count            = 2
  location            = "West Europe"
  vm_password         = "P@ssw0rd1234"
}
```

## Variable Reference

### Required variables

| Variable Name         | Description                                               | Type   |
|-----------------------|-----------------------------------------------------------|--------|
| `resource_group_name` | The resource group in which the resources will be created | string |
| `vm_count`            | The number of VMs to create                               | number |
| `location`            | The Azure region in which the resources will be created   | string |
| `vm_password`         | The password for the VMs                                  | string |

## Optional variables

| Variable Name           | Description                                                                                                                       | Type                                                                    | Default Value                                              |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------|------------------------------------------------------------|
| `vm_size`               | The size of the VMs to create                                                                                                     | string                                                                  | Standard_DS1_v2                                            |
| `vm_username`           | The username for the VMs                                                                                                          | string                                                                  | azureuser                                                  |
| `vm_name_prefix`        | The prefix to use for the VM names                                                                                                | string                                                                  | workshop-vm                                                |
| `vnet_name`             | The name of the VNet to create                                                                                                    | string                                                                  | workshop-vnet                                              |
| `vnet_address_space`    | The address space for the VNet                                                                                                    | list(string)                                                            | ["10.42.0.0/16"]                                           |
| `subnet_name`           | The name of the subnet to create                                                                                                  | string                                                                  | workshop-subnet                                            |
| `subnet_address_prefix` | The address prefix for the subnet                                                                                                 | list(string)                                                            | ["10.42.0.0/24"]                                           |
| `nsg_rules`             | A mapping of security rules to apply to the NSG                                                                                   | list(object({ name = string, priority = number, port_range = string })) | [{ name = "allow_ssh", priority = 100, port_range = "22"}] |
| `nic_name_prefix`       | The prefix to use for the NIC names                                                                                               | string                                                                  | workshop-nic                                               |
| `public_ip_name_prefix` | The prefix to use for the public IP names                                                                                         | string                                                                  | workshop-pip                                               |
| `create_dns_entries`    | Whether to create DNS entries for the VMs. Remember to set `dns_zone_name` and `dns_zone_rg` when setting this variable to `true` | bool                                                                    | false                                                      |
| `dns_zone_name`         | The name of the DNS zone to use. This needs to be set if `create_dns_entries` is set to `true`                                    | string                                                                  | change_me                                                  |
| `dns_zone_rg`           | The resource group in which the DNS zone is located. This needs to be set if `create_dns_entries` is set to `true`                | string                                                                  | change_me                                                  |
| `workshop_name`         | The name of the workshop, this will be used as a subdomain when making use of a dns zone                                          | string                                                                  | workshop                                                   |
| `use_ssh_key`           | Whether to use SSH key for the VMs. Remember to set `ssh_key_name` and `ssh_key_rg` when setting this variable to `true`          | bool                                                                    | false                                                      |
| `ssh_key_name`          | The name of the SSH key to use. This needs to be set if `use_ssh_key` is set to `true`                                            | string                                                                  | change_me                                                  |
| `ssh_key_rg`            | The resource group in which the SSH key is located. This needs to be set if `use_ssh_key` is set to `true`                        | string                                                                  | change_me                                                  |
| `tags`                  | A mapping of tags to assign to the resources                                                                                      | map(string)                                                             | {}                                                         |
