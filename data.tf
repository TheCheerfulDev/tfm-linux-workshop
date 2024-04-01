data "azurerm_ssh_public_key" "ssh-key" {
  count               = var.use_ssh_key ? 1 : 0
  name                = var.ssh_key_name
  resource_group_name = var.ssh_key_rg
}