output "public_ip_addresses" {
  value = [for i in azurerm_linux_virtual_machine.vm : i.public_ip_address]
}