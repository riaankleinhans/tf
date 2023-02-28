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

resource "null_resource" "install_curl" {
  provisioner "local-exec" {
    command = "sudo apt install -y curl"
  }
}

resource "null_resource" "install_gparted" {
  provisioner "local-exec" {
    command = "sudo apt install -y gparted"
  }
}

resource "null_resource" "install_tmate" {
  provisioner "local-exec" {
    command = "sudo apt install -y tmate"
  }
}

resource "null_resource" "install_kubectl" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
      chmod +x kubectl
      sudo mv kubectl /usr/local/bin/
    EOT
  }
}

resource "null_resource" "install_docker" {
  provisioner "local-exec" {
    command = <<-EOT
      sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io
      #sudo usermod -aG docker ${USER}
      sudo usermod -aG docker riaan-ttb
    EOT
  }
}
