output "vm_public_ips" {
  value = [for i in azurerm_linux_virtual_machine.vm : i.public_ip_address]
}

output "vm_ids" {
  value = [for i in azurerm_linux_virtual_machine.vm : i.id]
}