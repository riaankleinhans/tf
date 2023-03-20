TARGET_USER=$1
apt-get update && sudo apt-get -y upgrade
apt-get install -y \
    htop \
    wget \
    curl \
    gparted \
    tmate \
    tmux \
    vim \
    pwgen \
    openssh-server \
    virtualbox \
    apt-transport-https \
    ca-certificates \
    gnupg-agent \
    software-properties-common \
    ffmpeg \
    blender
curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
mv kubectl /usr/local/bin/
chmod +x /usr/local/bin/kubectl
apt-get install -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker $TARGET_USER
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.12.0/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/kind
# From https://coder.com/docs/v2/latest/install/install.sh
curl -fsSL https://coder.com/install.sh | sh
wget https://zoom.us/client/latest/zoom_amd64.deb
dpkg -i ./zoom_amd64.deb
rm zoom_amd64.deb
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg -i google-chrome-stable_current_amd64.deb
## Are you sure you need this?
apt-get -y install -f
wget https://downloads.slack-edge.com/releases/linux/4.29.149/prod/x64/slack-4.29.149-0.1.el8.x86_64.rpm
dpkg -i slack-4.29.149-0.1.el8.x86_64.rpm
apt-get -y install -f
# OBS
add-apt-repository ppa:obsproject/obs-studio -y
apt-get update
apt-get -y install obs-studio
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
apt-get -y install ./teamviewer_amd64.deb
teamviewer_amd64.deb
