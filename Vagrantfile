# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

require 'fileutils'

# --- Check for missing plugins
required_plugins = %w( vagrant-alpine vagrant-timezone vagrant-sudo-rsync)
plugin_installed = false
required_plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    system "vagrant plugin install #{plugin}"
    plugin_installed = true
  end
end
# --- If new plugins installed, restart Vagrant process
if plugin_installed === true
  exec "vagrant #{ARGV.join' '}"
end


# Defaults for config options defined in CONFIG
$num_nodes = 2
$master_name = "master"
$node_prefix = "node"

# select os to install on {alpine,ubuntu,centos}
# Sizes:
# OS     Ver   Download  Installed  On disk
# alpine  3.10  102Mb      0.7Gb     0.4Gb
# ubuntu 18.04  307Mb      1.5Gb     1.2Gb
# centos     7  382Mb      3.3Gb     1.4Gb
$OS_VERSION = "alpine"

$http_port = 8080
$https_port = 8443   

$enable_serial_logging = false

FILES_PATH= File.join(File.dirname(__FILE__), "files")
CONFIG = File.join(File.dirname(__FILE__), "config.rb")

# Attempt to apply the deprecated environment variable NUM_INSTANCES to
# $num_instances while allowing config.rb to override it
if ENV["NUM_INSTANCES"].to_i > 0 && ENV["NUM_INSTANCES"]
  $num_instances = ENV["NUM_INSTANCES"].to_i
end

if File.exist?(CONFIG)
  require CONFIG
end




Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "alpine/alpine64"
  #config.vm.box_version = "3.6.0"
  if $OS_VERSION == "centos" then
    config.vm.box = "centos/7"
  else
    if $OS_VERSION == "ubuntu" then
      config.vm.box = "ubuntu/bionic64"
    else
      config.vm.box = "generic/alpine310"
      $OS_VERSION = "alpine"
    end
  end
  #config.vm.box = 
  #config.vm.box = "coreos-#{$update_channel}"
  #config.vm.box_url = "https://#{$update_channel}.release.core-os.net/amd64-usr/current/coreos_production_vagrant_virtualbox.json"
  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
   config.vm.provider "virtualbox" do |vb|
     # Display the VirtualBox GUI when booting the machine
     vb.gui = false
  
     # Customize the amount of memory on the VM:
     vb.memory = "1024"
     vb.cpus = 1
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  (1..$num_nodes).each do |i|

    if i == 1 then
      $vm_name= $master_name
    else
      $vm_name="%s-%02d" % [$node_prefix, i-1]
    end


    if $enable_serial_logging
      logdir = File.join(File.dirname(__FILE__), "log")
      FileUtils.mkdir_p(logdir)

      serialFile = File.join(logdir, "%s-serial.txt" % $vm_name)
      FileUtils.touch(serialFile)

      config.vm.provider :virtualbox do |vb, override|
        vb.customize ["modifyvm", :id, "--uart1", "0x3F8", "4"]
        vb.customize ["modifyvm", :id, "--uartmode1", serialFile]
      end
    end

    config.vm.define $vm_name do | config |

      if i == 1 then

        config.vm.network "forwarded_port", guest: 6443, host: 6443, host_ip: "127.0.0.1", guest_ip: "192.168.50.10"
         
        if $http_port > 0 then
          config.vm.network "forwarded_port", guest: 80, host: $http_port, host_ip: "127.0.0.1"
        end

        if $https_port > 0 then
          config.vm.network "forwarded_port", guest: 443, host: $https_port, host_ip: "127.0.0.1"
        end

        config.vm.hostname = "master"
        vm_name = "master"
        config.vm.network "private_network", ip: "192.168.50.10"
        config.vm.provision "file", source: "#{FILES_PATH}",  :destination => "/tmp/user-data"
        config.vm.provision :shell, inline: "/tmp/user-data/install-#{$OS_VERSION}.sh micro-server", :privileged => true
        #config.vm.provision :shell, inline: "/tmp/user-data/install-k8-ubuntu.sh micro-server", :privileged => true
      else
        config.vm.hostname = $vm_name
        vm_name = $vm_name
        config.vm.network "private_network", ip: "192.168.50.#{i+9}"
        config.vm.provision "file", source: "#{FILES_PATH}",  :destination => "/tmp/user-data"
        config.vm.provision :shell, inline: "/tmp/user-data/install-#{$OS_VERSION}.sh agent", :privileged => true

      end
    end
  end

  # setup nfs server

end
