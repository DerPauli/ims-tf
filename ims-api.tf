resource "digitalocean_droplet" "ims-api" {
    
    image = "ubuntu-19-04-x64"
    name = "ims-api"
    region = "fra1"
    size = "1gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    depends_on = ["${digitalocean_droplet.ims-db}"]

  connection {
      host = "${digitalocean_droplet.ims-api.ipv4_address}"
      type = "ssh"
      user = "root"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      # install npm and dependecies for sofa / graphql
      # TODO: maybe add swagger / openapi for documentation
      "sudo apt-get install -y gcc-c++ make git",
      "curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",

      # get repo
      "git clone https://${var.gh_token}@github.com/DerPauli/ims-api.git",
      "cd ims-api",

      "npm install",
      "npm install pm2 -g",

      # create database
      "npx sequelize db:create",
      "npx sequelize db:migrate",
      "npx sequelize db:seed:all",

      # start api
      "pm2 start src/pre.js",

      # note certbot has to be started manually
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      "sudo add-apt-repository universe -y",
      "sudo add-apt-repository ppa:certbot/certbot -y",
      "sudo apt-get update",

      "sudo apt-get install -y certbot"
    ]
  }
}