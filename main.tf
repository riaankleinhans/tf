resource "null_resource" "install_htop" {
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get install -y htop"
  }
}
