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

resource "null_resource" "write_username_to_file" {
  provisioner "local-exec" {
    command = "whoami > /tmp/current_user.txt"
  }
}


resource "null_resource" "install_docker" {
  provisioner "local-exec" {
    command = <<-EOT
      sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
      sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io
      sudo usermod -aG docker $(cat /tmp/current_user.txt)
    EOT
  }
}

resource "null_resource" "go-lang" {
  provisioner "local-exec" {
    command = "sudo apt install -y golang-go"
  }
}

resource "null_resource" "install_kind" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
      chmod +x ./kind
      sudo mv ./kind /usr/local/bin/kind
    EOT
  }
}

resource "null_resource" "install_coder" {
  provisioner "local-exec" {
    command = <<EOT
      mkdir -p ~/.cache/coder &&
      curl -#fL -o ~/.cache/coder/coder_0.17.4_amd64.deb.incomplete -C - https://github.com/coder/coder/releases/download/v0.17.4/coder_0.17.4_linux_amd64.deb &&
      mv ~/.cache/coder/coder_0.17.4_amd64.deb.incomplete ~/.cache/coder/coder_0.17.4_amd64.deb &&
      sudo dpkg --force-confdef --force-confold -i ~/.cache/coder/coder_0.17.4_amd64.deb
    EOT
  }
}
