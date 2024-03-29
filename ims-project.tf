resource "digitalocean_project" "IncidentMS" {

  name        = "IncidentMS"
  description = "Incident Management System"
  environment = "Development"
  resources   = ["${digitalocean_droplet.ims-api.urn}", "${digitalocean_droplet.ims-db.urn}",
                 "${digitalocean_domain.view.urn}", "${digitalocean_domain.api.urn}",
                 "${digitalocean_droplet.ims-ui.urn}", "${digitalocean_domain.grafana.urn}"]

}