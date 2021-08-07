# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "bento/ubuntu-16.04"

  config.vm.box_check_update = true

  config.vm.provider "virtualbox" do |vb|
      vb.name = "dev-vm-docker"
      vb.memory = "2046"
      vb.cpus = 2
      vb.customize ['modifyvm', :id, '--vram', '16']
      vb.customize ['modifyvm', :id, '--vrde', 'off']
      vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
      vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
      vb.customize [ "guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", 5000 ]
end

  config.dns.tld = 'test'
  config.vm.hostname = 'dev-vm'

  config.vm.network 'private_network', ip: '192.168.101.99'

  config.vm.synced_folder "../", "/home/vagrant/repos"
  config.vm.synced_folder '.', '/vagrant'

  config.ssh.forward_agent = true

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell",
                      env: { DEBIAN_FRONTEND: "noninteractive" },
                      inline: <<-SHELL

    # add yarn, docker, and heroku keys and repositories
    curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
    add-apt-repository "deb https://dl.yarnpkg.com/debian/ stable main"
    curl -sSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
    curl -sSL https://cli-assets.heroku.com/apt/release.key | sudo apt-key add -
    sudo add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./"

    # update packages
    apt-get update -y

    # upgrade packages asap
    apt-get upgrade -y

    # install jemalloc for better memory utilization and performance
    # utilize jemalloc through LD_PRELOAD env variable, similar to production usage
    apt-get install -y libjemalloc-dev

    # install DKMS for virtual box
    apt-get install -y virtualbox-dkms

    # zsh shell and rbenv dependencies
    apt-get install -y build-essential zsh zsh-syntax-highlighting
    curl -sSL "https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh" | sh

    # install docker & docker-compose
    apt-get install -y docker-ce
    usermod -aG docker vagrant
    curl -sSL "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    docker --version
    docker-compose --version

    # ruby dependencies
    apt-get install -y libssl-dev libreadline-dev zlib1g-dev

    # sqllite and yaml libraries
    apt-get install -y libyaml-dev libsqlite3-dev sqlite3

    # install yarn to enable webpack
    apt-get install -y yarn

    # postgres & redis clients
    apt-get install -y postgresql-client-10 libpq-dev redis-tools

    # add current heroku tools
    apt-get install -y  heroku

    # add pip3 and the python virtual environment provider
    apt-get install -y python3-pip python3-venv

    # add aws and eb
    pip3 install awscli --upgrade --user
    pip3 install awsebcli --upgrade --user

    # uninstall old nodejs version (pre v8)
    apt-get remove -y nodejs
  SHELL

  config.vm.provision "shell",
                      privileged: false,
                      env: { DEBIAN_FRONTEND: "noninteractive" },
                      inline: <<-SCRIPT

    # configure ZSH and make default prompt
    mkdir ~/.bin
    cp /vagrant/setup/.zshrc ~/.
    sudo sed -i -e 's|/home/vagrant:/bin/bash|/home/vagrant:/usr/bin/zsh|g' /etc/passwd

    # create symbolic link to python 3
    ln -s /usr/bin/python3 $HOME/.bin/python
    ln -s /usr/bin/pip3 $HOME/.bin/pip

    # install Node Version Manager; works as of pre-v0.33.12
    curl -sSLo- https://raw.githubusercontent.com/creationix/nvm/master/install.sh | sh
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

    # install Node v8
    nvm install --no-progress v8.10.0

    # configure rbenv and install ruby versions
    git clone https://github.com/rbenv/rbenv.git ~/.rbenv
    git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
    cd ~/.rbenv && src/configure && make -C src && cd ~

    export PATH=$HOME/.rbenv/bin:$PATH

    eval "$(rbenv init -)"

    rbenv install 2.5.3
    rbenv install 2.4.5
    rbenv global 2.4.5

    rbenv rehash

    # install bundler
    gem install bundler -v 1.17.3

    git clone https://github.com/ac21/vimfiles.git ~/.vim
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    ln -s ~/.vim/vimrc ~/.vimrc
    mkdir ~/.vim/colors
    curl -sSL https://github.com/sjl/badwolf/raw/master/colors/badwolf.vim > ~/.vim/colors/badwolf.vim
    sed -i 's/colorscheme github/colorscheme badwolf/g' ~/.vimrc
    vim +PluginInstall +qall &> /dev/null

    # configure localhost to access docker services by name
    sudo sed -i '/127.0.0.1\tlocalhost/a 127.0.0.1\tdb' /etc/hosts
    sudo sed -i '/127.0.0.1\tlocalhost/a 127.0.0.1\tstore' /etc/hosts
    sudo sed -i '/127.0.0.1\tlocalhost/a 127.0.0.1\tsearch' /etc/hosts

    # install circleci cli
    curl -fLSs https://circle.ci/cli | sudo bash

    # setup tmux
    cp /vagrant/setup/.tmux.conf ~/.

    # copy user experience files
    cp /vagrant/setup/.Guardfile ~/.Guardfile
    cp /vagrant/setup/.gitconfig ~/.gitconfig

    # compress file as much as possible to prepare for upload
    sudo apt-get autoremove -y
    sudo apt-get clean
    sudo dd if=/dev/zero of=/EMPTY bs=1M
    sudo rm -f /EMPTY
  SCRIPT
end
