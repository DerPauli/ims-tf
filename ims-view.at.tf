# Create a new domain record
resource "digitalocean_domain" "www-ui" {
   name = "ims-view.at"
   ip_address = "${digitalocean_droplet.ims-ui.ipv4_address}"
}


# Add a record to the domain
resource "digitalocean_record" "CNAME-www-ui" {
  domain = "${digitalocean_domain.www-ui.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}