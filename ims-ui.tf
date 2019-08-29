resource "digitalocean_droplet" "ims-ui" {
    
    image = "centos-7-x64"
    name = "ims-ui"
    region = "fra1"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

  connection {
      host = "${digitalocean_droplet.ims-ui.ipv4_address}"
      type = "ssh"
      user = "root"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      # install npm and dependecies for sofa / graphql
      # TODO: maybe add swagger / openapi for documentation
      "sudo yum install -y gcc-c++ make",
      "curl -sL https://rpm.nodesource.com/setup_6.x | sudo -E bash -",
      "yum -y install nodejs"
    ]
  }
}