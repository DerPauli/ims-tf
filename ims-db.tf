resource "digitalocean_droplet" "ims-db" {
    
    image = "centos-7-x64"
    name = "ims-db"
    region = "fra1"
    size = "512mb"
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

  provisioner "remote-exec" {
    inline = [
      # install mysql
      "sudo yum update",
      "yum -y install wget",
      "wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm",
      "sudo rpm -ivh mysql-community-release-el7-5.noarch.rpm",
      "yum -y update",
      "sudo yum -y install mysql-server",
      "sudo systemctl start mysqld"
    ]
  }
}