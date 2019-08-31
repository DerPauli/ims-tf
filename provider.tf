variable "do_token" {}
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}

variable "gh_token" {}

variable "db_pass" {}

variable "graf_pass" {}

provider "digitalocean" {
  token = "${var.do_token}"
}