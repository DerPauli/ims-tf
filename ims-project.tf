resource "digitalocean_project" "IMS" {

  name        = "IMS"
  description = "Incident Management System"
  environment = "Development"
  resources   = ["${digitalocean_droplet.ims-api.urn}", "${digitalocean_droplet.ims-db.urn}",
                 "${digitalocean_domain.default.urn}", "${digitalocean_domain.api.urn}",
                 "${digitalocean_droplet.ims-ui.urn}"]

}