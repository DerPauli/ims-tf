# Create a new domain record
resource "digitalocean_domain" "api" {
   name = "api.tasklist.at"
   ip_address = "${digitalocean_droplet.ims-api.ipv4_address}"
}

resource "digitalocean_domain" "default" {
   name = "tasklist.at"
   ip_address = "${digitalocean_droplet.ims-ui.ipv4_address}"
}

# Add a record to the domain
resource "digitalocean_record" "CNAME-www" {
  domain = "${digitalocean_domain.default.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}