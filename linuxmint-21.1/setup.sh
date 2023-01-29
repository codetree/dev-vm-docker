if [ "$(id -u)" -ne 0 ]; then
  echo running as $(id)
else
  echo running as $(id)
	echo 'This script should not be run as root'
	exit 1
fi

# install base packages
sudo apt install -y vim xrdp tmux git zsh


## Configure xrdp for RDP and vsock connections
# use vsock and tcp ports.
sudo sed -i_orig -e 's|port=3389|port=vsock://-1:3389 tcp://:3389|g' /etc/xrdp/xrdp.ini
# use vsock transport.
sudo sed -i_orig -e 's/use_vsock=false/use_vsock=true/g' /etc/xrdp/xrdp.ini
# use rdp security.
sudo sed -i_orig -e 's/security_layer=negotiate/security_layer=rdp/g' /etc/xrdp/xrdp.ini
# remove encryption validation.
sudo sed -i_orig -e 's/crypt_level=high/crypt_level=none/g' /etc/xrdp/xrdp.ini


# copy base config files for tmux, vim and zshrc
cp ./setup/.* ~/.

# install oh my zsh;  https://ohmyz.sh/#install
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install rbenv
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
mkdir ~/.rbenv/plugins
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
# add libraries for ruby install
sudo apt install -y curl autoconf bison build-essential libssl-dev libyaml-dev \
  libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm6 libgdbm-dev libdb-dev

# install bundler
gem install bundler --version 2.2.15

# install nvm
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash

# install pyenv
curl https://pyenv.run | bash

# install docker
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Note:  only works with ubuntu jammy due to hardcoding "jammy" instead of "$(lsb_release -cs)";  required because LinuxMint returns wrong codename
echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      jammy stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

sudo usermod -aG docker $USER
newgrp docker

# install vscode
sudo apt install -y software-properties-common apt-transport-https

curl -sSL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/ms-vscode-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/ms-vscode-keyring.gpg] https://packages.microsoft.com/repos/vscode \
  stable main" | sudo tee /etc/apt/sources.list.d/vscode.list > /dev/null

sudo apt install -y code

# install aws cli v2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "~/awscliv2.zip"
unzip ~/awscliv2.zip ~
sudo ~/aws/install
