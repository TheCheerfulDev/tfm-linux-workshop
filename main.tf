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

resource "azurerm_resource_group" "workshop-rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.workshop-rg.location
  resource_group_name = azurerm_resource_group.workshop-rg.name
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.workshop-rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_address_prefix
}

resource "azurerm_network_security_group" "nsg" {
  name                = "workshop-nsg"
  location            = azurerm_resource_group.workshop-rg.location
  resource_group_name = azurerm_resource_group.workshop-rg.name
}

resource "azurerm_network_security_rule" "nsg-rule" {
  for_each                    = var.nsg_rules
  name                        = each.key
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.workshop-rg.name
  network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "public-ip" {
  count               = var.vm_count
  name                = "${var.public_ip_name_prefix}-${count.index}"
  location            = azurerm_resource_group.workshop-rg.location
  resource_group_name = azurerm_resource_group.workshop-rg.name
  allocation_method   = "Dynamic"
  tags                = var.tags
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "${var.nic_name_prefix}-${count.index}"
  location            = azurerm_resource_group.workshop-rg.location
  resource_group_name = azurerm_resource_group.workshop-rg.name
  tags                = var.tags

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
  resource_group_name             = azurerm_resource_group.workshop-rg.name
  location                        = azurerm_resource_group.workshop-rg.location
  size                            = var.vm_size
  admin_username                  = var.vm_username
  admin_password                  = var.vm_password
  disable_password_authentication = false
  network_interface_ids           = [
    azurerm_network_interface.nic[count.index].id,
  ]

  dynamic "admin_ssh_key" {
    for_each = var.use_ssh_key ? [1] : []
    content {
      username   = var.vm_username
      public_key = var.use_ssh_key ? data.azurerm_ssh_public_key.ssh-key[0].public_key : null
    }
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

  tags = var.tags
}

resource "azurerm_dns_a_record" "ordina-platforms_nl" {
  count               = var.create_dns_entries ? var.vm_count : 0
  name                = "vm-${count.index}.${var.workshop_name}"
  zone_name           = var.dns_zone_name
  resource_group_name = var.dns_zone_rg
  ttl                 = 300
  target_resource_id  = azurerm_public_ip.public-ip[count.index].id
}

