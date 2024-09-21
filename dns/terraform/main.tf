resource "cloudflare_record" "backend" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "backend"
  content = "172.31.37.118"
  type    = "A"
  ttl     = 60
  proxied = false
}


resource "cloudflare_record" "db" {
  zone_id = data.cloudflare_zone.zone.id
  name    = "db"
  content = "172.31.33.52"
  type    = "A"
  ttl     = 60
  proxied = false
}

# resource "cloudflare_record" "db" {
#   zone_id = data.cloudflare_zone.zone.id
#   name    = "db"                      # Ensure the name is in quotes
#   content = "172.31.33.52"            # Ensure the IP address is in quotes
#   type    = "A"
#   ttl     = 60
#   proxied = false
# }


# resource "cloudflare_record" "app" {
#   zone_id = data.cloudflare_zone.zone.id
#   name    = var.component
#   value   = module.bastion.public_ip
#   type    = "A"
#   ttl     = 1
#   proxied = false
# }
