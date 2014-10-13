# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # All Vagrant configuration is done here. The most common configuration
  # options are documented and commented below. For a complete reference,
  # please see the online documentation at vagrantup.com.

  # Every Vagrant virtual environment requires a box to build off of.
  # A standard CentOS 6.5 box with Puppet 3.6.2 preinstalled
  # config.vm.box = "puppetlabs/centos-6.5-64-puppet"
  config.vm.box = "puppetlabs/centos-6.5-64-nocm"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-65-x64-virtualbox-puppet.box"

  # Set hostname
  config.vm.host_name = "rhel6.com"

  # # Enable SSH agent forwarding for github
  # # https://coderwall.com/p/p3bj2a
  config.ssh.username = 'vagrant'
  config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key','~/.ssh/id_rsa' ]
  config.ssh.forward_agent = true

  # install ruby 1.9
  # http://rvm.io/integration/vagrant
  config.vm.provision :shell, :path => "provision/shell/install_puppet.sh" 
  # config.vm.provision :shell, :path => "provision/shell/install_rvm.sh",  :args => "stable"
  # config.vm.provision :shell, :path => "provision/shell/install_ruby.sh", :args => "1.9.3 ruby_gem open3_backport ruby-json librarian-puppet"
  # config.vm.provision :shell, :path => "provision/shell/install_ruby.sh", :args => "2.0.0 ruby_gem open3_backport ruby-json librarian-puppet"
 
  # install librarian-puppet and run it to install puppet common modules.
  # This has to be done before puppet provisioning so that modules are available
  # when puppet tries to parse its manifests
  config.vm.provision :shell, :path => "provision/shell/librarian-puppet.sh", :args => "'/vagrant/provision/puppet'"

  # # install docker as some puppet code which builds magma needs docker
  # config.vm.provision :shell, :path => "provision/shell/install_docker.sh"

  # run puppet
  config.vm.provision "puppet" do |d|
    d.manifests_path = 'provision/puppet/manifests'
    d.manifest_file = 'site.pp'
    d.module_path = [ 'provision/puppet/modules' ]
  end

end
