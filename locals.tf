locals {
  ssh_key_rg    = "rg-markhendriks-keys"
  ssh_key_name  = "bash-workshop-key"
  dns_zone_name = "ordina-platforms.nl"
  dns_zone_rg   = "rg-dns-ordina-platforms.nl"
  tags          = {
    Owner = "mark.hendriks@ordina.nl"
  }
}
