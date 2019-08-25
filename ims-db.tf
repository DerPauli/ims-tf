# Create a new database cluster
resource "digitalocean_database_cluster" "ims-db" {
  name       = "ims-db"
  engine     = "mysql"
  version    = "8"
  size       = "db-s-1vcpu-1gb"
  region     = "fra1"
  node_count = 1
}