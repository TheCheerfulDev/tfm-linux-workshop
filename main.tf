terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.97.1"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_ssh_public_key" "ssh-key" {
  name                = local.ssh_key_name
  resource_group_name = local.ssh_key_rg
}

resource "azurerm_resource_group" "bash-workshop" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.bash-workshop.location
  resource_group_name = azurerm_resource_group.bash-workshop.name
  tags                = local.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.bash-workshop.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "public-ip" {
  count               = var.vm_count
  name                = "${var.public_ip_name_prefix}-${count.index}"
  location            = azurerm_resource_group.bash-workshop.location
  resource_group_name = azurerm_resource_group.bash-workshop.name
  allocation_method   = "Dynamic"
  tags                = local.tags
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.nic_name_prefix}-${count.index}"
  location            = azurerm_resource_group.bash-workshop.location
  resource_group_name = azurerm_resource_group.bash-workshop.name
  tags                = local.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public-ip[count.index].id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  count                           = var.vm_count
  name                            = "${var.vm_name_prefix}-${count.index}"
  resource_group_name             = azurerm_resource_group.bash-workshop.name
  location                        = azurerm_resource_group.bash-workshop.location
  size                            = var.vm_size
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids           = [
    azurerm_network_interface.nic[count.index].id,
  ]

  admin_ssh_key {
    username   = var.vm_username
    public_key = data.azurerm_ssh_public_key.ssh-key.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = local.tags
}

resource "azurerm_dns_a_record" "ordina-platforms_nl" {
  count               = var.create_dns_entries ? var.vm_count : 0
  name                = "vm-${count.index}.bashworkshop"
  zone_name           = local.dns_zone_name
  resource_group_name = local.dns_zone_rg
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.public-ip[count.index].id
}

resource "local_file" "ip_file" {
  filename = "cursist-vm-inventory-${var.environment}.ini"
  content  = join("\n", [for i in azurerm_linux_virtual_machine.vm : i.public_ip_address])
}
