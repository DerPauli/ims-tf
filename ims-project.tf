resource "digitalocean_project" "IMS" {

  name        = "IMS"
  description = "Incident Management System"
  environment = "Development"
  resources   = ["${digitalocean_droplet.ims-api.urn}", "${digitalocean_database_cluster.ims-db.urn}"]

}