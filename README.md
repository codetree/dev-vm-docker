# DEV-VM-DOCKER

Build the Box/Package for the Default Ruby Dev Environment.

Base Configuration is:

1. Ubuntu 16.04
2. Ruby 2.5
3. Nodejs 8.10
4. Rails 5.2


## Setup

1. Fork this directory
2. Install Vagrant `https://www.vagrantup.com/`
3. Install VirtualBox `https://www.virtualbox.org/`
4. Install VBGuest to keep Guest Additions in sync.  `vagrant plugin install vagrant-vbguest`
5. start vagrant with `vagrant up` to download and configure the box image
6. Login into vagrant using 'vagrant ssh`

## Update box configuration and upload it

1. run `BOX_VERSION=[VERSION] make upload_new_version`
