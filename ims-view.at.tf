# Create a new domain record
resource "digitalocean_domain" "grafana" {
   name = "ims-view.at"
   ip_address = "${digitalocean_droplet.ims-db.ipv4_address}"
}


# Add a record to the domain
resource "digitalocean_record" "CNAME-www-grafana" {
  domain = "${digitalocean_domain.grafana.name}"
  type   = "CNAME"
  name   = "www"
  value  = "@"
}