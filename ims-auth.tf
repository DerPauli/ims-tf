resource "digitalocean_droplet" "ims-auth" {
    
    image = "ubuntu-19-04-x64"
    name = "ims-auth"
    region = "fra1"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    depends_on = [digitalocean_droplet.ims-db]

  connection {
      host = "${digitalocean_droplet.ims-auth.ipv4_address}"
      type = "ssh"
      user = "root"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "file" {
    source      = "scripts/setup-auth.sh"
    destination = "/root/setup-auth.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/setup-auth.sh",
      "/root/setup-auth.sh ${var.gh_token} ${digitalocean_droplet.ims-db.ipv4_address}"
    ]
  }
}