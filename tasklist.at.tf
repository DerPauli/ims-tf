# Create a new domain record
resource "digitalocean_domain" "api" {
   name = "api.tasklist.at"
   ip_address = "${digitalocean_droplet.ims-api.ipv4_address}"
}

resource "digitalocean_domain" "view" {
   name = "view.ims-view.at"
   ip_address = "${digitalocean_droplet.ims-ui.ipv4_address}"
}