resource "null_resource" "sync_apt_repos" {
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get -y upgrade"
  }
}

resource "null_resource" "install_htop" {
  provisioner "local-exec" {
    command = "sudo apt-get install -y htop"
  }
  depends_on = [null_resource.sync_apt_repos]
}

resource "null_resource" "install_curl" {
  provisioner "local-exec" {
    command = "sudo apt install -y curl"
  }
  depends_on = [null_resource.install_htop]
}

resource "null_resource" "install_gparted" {
  provisioner "local-exec" {
    command = "sudo apt install -y gparted"
  }
  depends_on = [null_resource.install_curl]
}

resource "null_resource" "install_tmate" {
  provisioner "local-exec" {
    command = "sudo apt install -y tmate"
  }
  depends_on = [null_resource.install_gparted]
}

resource "null_resource" "install_vim" {
  provisioner "local-exec" {
    command = "sudo apt install -y vim"
  }
  depends_on = [null_resource.install_tmate]
}

resource "null_resource" "install_pwgen" {
  provisioner "local-exec" {
    command = "sudo apt install -y pwgen"
  }
  depends_on = [null_resource.install_vim]
}

resource "null_resource" "install_kubectl" {
  provisioner "local-exec" {
    command = <<-EOT
      curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
      chmod +x kubectl
      sudo mv kubectl /usr/local/bin/
    EOT
  }
  depends_on = [null_resource.install_pwgen]
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
  depends_on = [null_resource.write_username_to_file,null_resource.install_kubectl]
}

resource "null_resource" "openssh-server" {
  provisioner "local-exec" {
    command = "sudo apt install -y openssh-server"
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
  depends_on = [null_resource.openssh-server]
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

resource "null_resource" "virtualbox_installation" {
  provisioner "local-exec" {
    command = "sudo apt-get update && sudo apt-get install -y virtualbox"
  }
  depends_on = [null_resource.install_coder]
}

#resource "null_resource" "emacs_broadway_installation" {
#   provisioner "local-exec" {
#    command = "sudo apt-get update && sudo apt-get install -y emacs libgtk-3-0 xvfb && Xvfb :0 -screen 0 1024x768x24 & DISPLAY=:0 emacs --fg-daemon=broadway -f server-start && echo 'Emacs with Broadway support installed successfully.'"
#   }
#  depends_on = [null_resource.virtualbox_installation]
#}

resource "null_resource" "install_zoom" {
  provisioner "local-exec" {
    command = <<EOT
      wget https://zoom.us/client/latest/zoom_amd64.deb
      sudo apt-get update
      sudo apt-get -y install ./zoom_amd64.deb
      rm zoom_amd64.deb
    EOT
  }
 depends_on = [null_resource.virtualbox_installation]
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
      wget https://downloads.slack-edge.com/linux_releases/slack-desktop-4.17.0-amd64.deb -O slack.deb
      sudo apt-get update
      sudo apt-get -y install gconf2 gconf-service libgtk2.0-0 libnotify4 libnss3 libxss1 libxtst6 xdg-utils
      sudo dpkg -i slack.deb
      sudo apt-get -y install -f
      rm slack.deb
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

resource "null_resource" "install_zoom" {
  provisioner "local-exec" {
    command = <<EOT
      wget https://zoom.us/client/latest/zoom_amd64.deb
      sudo apt-get update
      sudo apt-get -y install ./zoom_amd64.deb
      rm zoom_amd64.deb
    EOT
  }
}
