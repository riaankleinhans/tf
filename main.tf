resource "null_resource" "sync_apt_repos" {
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get -y upgrade"
  }
}

resource "null_resource" "install_htop" {
  provisioner "local-exec" {
    command = "sudo apt-get install -y htop"
  }
}
