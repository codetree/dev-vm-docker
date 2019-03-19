# DEV-VM-DOCKER

Build the Box/Package for the Default Ruby Dev Environment.

Base Configuration is:

1. Ubuntu 16.04
2. Ruby 2.4/2.5
3. Nodejs 8.10


## Setup

1. Fork this directory
2. Install Vagrant `https://www.vagrantup.com/`
3. Install VirtualBox `https://www.virtualbox.org/`
4. Install VBGuest to keep Guest Additions in sync.  `vagrant plugin install vagrant-vbguest`
5. Install vagrant-dns to enable dns resolution from host to guest. `vagrant plugin install vagrant-dns`
6. start vagrant with `vagrant up` to build and configure the box image
7. restart box image after completion. `vagrant halt && vagrant up`
8. Login into vagrant using 'vagrant ssh`

