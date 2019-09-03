resource "digitalocean_droplet" "ims-db" {
    
    image = "ubuntu-19-04-x64"
    name = "ims-db"
    region = "fra1"
    size = "1gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

  connection {
      host = "${digitalocean_droplet.ims-db.ipv4_address}"
      type = "ssh"
      user = "root"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }
  provisioner "file" {
    source      = "scripts/setup-db.sh"
    destination = "/root/setup-db.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/setup-db.sh",
      "/root/setup-db.sh ${var.db_pass} ${var.gh_token} ${var.graf_pass}"
    ]
  }
}