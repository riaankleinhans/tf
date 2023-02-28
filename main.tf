resource "null_resource" "sync_apt_repos" {
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get -y upgrade"
  }
}

esource "null_resource" "install_htop" {
  provisioner "local-exec" {
    command = "sudo apt-get install -y htop"
  }
}

esource "null_resource" "install_curl" {
  provisioner "local-exec" {
    command = "sudo apt install -y curl"
  }
}
