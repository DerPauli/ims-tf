resource "digitalocean_droplet" "ims-ui" {
    
    image = "ubuntu-19-04-x64"
    name = "ims-ui"
    region = "fra1"
    size = "2gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    depends_on = [digitalocean_droplet.ims-api]

  connection {
      host = "${digitalocean_droplet.ims-ui.ipv4_address}"
      type = "ssh"
      user = "root"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "file" {
    source      = "scripts/setup-ui.sh"
    destination = "/root/setup-ui.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/setup-ui.sh",
      "/root/setup-ui.sh"
    ]
  }
}