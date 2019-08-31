resource "digitalocean_droplet" "ims-ui" {
    
    image = "ubuntu-19-04-x64"
    name = "ims-ui"
    region = "fra1"
    size = "2gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]

    depends_on = ["${digitalocean_droplet.ims-db}"]

  connection {
      host = "${digitalocean_droplet.ims-ui.ipv4_address}"
      type = "ssh"
      user = "root"
      private_key = "${file(var.pvt_key)}"
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl git",

      "curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -",
      "sudo apt-get install -y nodejs",

      "git clone https://github.com/DerPauli/ims-ui.git",
      "cd ims-ui/ims-frontend",


      # disable google analytics promt
      "export NG_CLI_ANALYTICS=ci",
      "npm install",
      "npm install -g pm2",
      "npm install -g @angular/cli",

      "sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 4200",
      "sudo ufw allow 4200",

      "ng build --prod",
      "pm2 serve dist/ims-frontend/ 80 --name Frontend"

    ]
  }
}