resource "null_resource" "sync_apt_repos" {
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get -y upgrade"
  }
}

resource "null_resource" "install_apt_packages" {
  provisioner "local-exec" {
    command = "sudo apt-get install -y htop curl gparted tmate tmux vim pwgen openssh-server virtualbox kitty"
  }
  depends_on = [null_resource.sync_apt_repos]
}


#EOT
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
  depends_on = [null_resource.write_username_to_file, null_resource.install_apt_packages]
}

resource "null_resource" "install_kubectl" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
      chmod +x kubectl
      sudo mv kubectl /usr/local/bin/
    EOT
  }
  depends_on = [null_resource.install_docker]
}

resource "null_resource" "install_kind" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
      chmod +x ./kind
      sudo mv ./kind /usr/local/bin/kind
    EOT
  }
  depends_on = [null_resource.install_kubectl]
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
  depends_on = [null_resource.install_kind, null_resource.install_docker]
}

resource "null_resource" "install_zoom" {
  provisioner "local-exec" {
    command = <<EOT
      wget https://zoom.us/client/latest/zoom_amd64.deb
      sudo apt-get update
      sudo apt-get -y install ./zoom_amd64.deb
      rm zoom_amd64.deb
    EOT
  }
  depends_on = [null_resource.install_coder]
}

resource "null_resource" "install_chrome" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update
      sudo apt-get -y install wget
      wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
      sudo dpkg -i google-chrome-stable_current_amd64.deb
      sudo apt-get -y install -f
    EOT
  }
  depends_on = [null_resource.install_zoom]
}

resource "null_resource" "install_slack" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update
      wget https://downloads.slack-edge.com/releases/linux/4.29.149/prod/x64/slack-4.29.149-0.1.el8.x86_64.rpm
      sudo dpkg -i slack-4.29.149-0.1.el8.x86_64.rpm
      sudo apt-get -y install -f
    EOT    
  }
  depends_on = [null_resource.install_chrome]
}

resource "null_resource" "install_obs_studio" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update
      sudo apt-get -y install ffmpeg
      sudo add-apt-repository ppa:obsproject/obs-studio -y
      sudo apt-get update
      sudo apt-get -y install obs-studio
    EOT
  }
  depends_on = [null_resource.install_slack]
}

resource "null_resource" "install_blender" {
  provisioner "local-exec" {
    command = <<EOT
      sudo apt-get update
      sudo apt-get -y install blender
    EOT
  }
  depends_on = [null_resource.install_obs_studio]
}

resource "null_resource" "install_teamviewer" {
  provisioner "local-exec" {
    command = <<EOT
      wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
      sudo apt-get update
      sudo apt-get -y install ./teamviewer_amd64.deb
      rm teamviewer_amd64.deb
    EOT
  }
  depends_on = [null_resource.install_blender]
}

resource "null_resource" "install_go" {
  provisioner "local-exec" {
    command = <<-EOT
      export GO_VERSION=1.20.2
      curl -sSL https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz | sudo tar -C /usr/local -xzf -
      export PATH=$PATH:/usr/local/go/bin
    EOT
  }
 depends_on = [null_resource.install_blender]
}

resource "null_resource" "install_vagrant" {
  provisioner "local-exec" {
    command = "wget https://releases.hashicorp.com/vagrant/2.2.18/vagrant_2.2.18_x86_64.deb && sudo dpkg -i vagrant_2.2.18_x86_64.deb"
  }
 depends_on = [null_resource.install_go]
}


resource "null_resource" "fix_broken_install" {
  provisioner "local-exec" {
    command = "sudo apt -y --fix-broken install"
  }
  depends_on = [null_resource.install_vagrant]
}

resource "null_resource" "autoremove" {
  provisioner "local-exec" {
    command = "sudo apt -y autoremove"
  }
  depends_on = [null_resource.fix_broken_install]
}


