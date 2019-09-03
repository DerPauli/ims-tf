resource "digitalocean_droplet" "ims-api" {
    
    image = "ubuntu-19-04-x64"
    name = "ims-api"
    region = "fra1"
    size = "1gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    depends_on = [digitalocean_droplet.ims-db]

  connection {
      host = "${digitalocean_droplet.ims-api.ipv4_address}"
      type = "ssh"
      user = "root"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "file" {
    source      = "scripts/setup-api.sh"
    destination = "/root/setup-api.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/setup-api.sh",
      "/root/setup-api.sh ${var.gh_token} ${digitalocean_droplet.ims-db.ipv4_address}"
    ]
  }
}