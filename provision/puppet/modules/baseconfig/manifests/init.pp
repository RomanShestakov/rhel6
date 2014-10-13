# -*- mode: puppet-mode -*-
# vi: set ft=ruby :

# == Class: baseconfig
#
# Performs initial configuration tasks for all Vagrant boxes.
#
class baseconfig {

  include curl
  
  # exec { 'apt-get update':
  #   command => 'apt-get update',
  #   path    => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
  # }
  
  # exec { 'apt-get -y install git':
  #   command => 'apt-get -y install git',
  #   path    => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
  #   require => Exec[ 'apt-get update' ],
  # }
  
  # exec { 'apt-get -y install gcc':
  #   command => '/usr/bin/apt-get -y install gcc',
  #   path    => "/usr/local/bin/:/bin/",
  # }

  # exec { 'apt-get -y install make':
  #   command => 'apt-get -y install make',
  #   path    => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
  # }

  if !defined(Package['wget']) {
    package{'wget':
      ensure => present,
    }
  }

  if !defined(Package['autoconf']) {
    package{'autoconf':
      ensure => present,
    }
  }

  # class { 'locales':
  #   default_locale  => 'en_US.UTF-8',
  #   locales         => ['en_US.UTF-8 UTF-8'],
  # }
  
  file { '/home/vagrant/.bashrc':
    owner  => 'vagrant',
    group  => 'vagrant',
    mode   => '0644',
    source => 'puppet:///modules/baseconfig/bashrc';
  }

  # exec { 'apt-get -y install autoconf':
  #   command => 'apt-get -y install autoconf',
  #   path    => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
  # }

  # exec { 'apt-get -y install ncurses-dev':
  #   command => 'apt-get -y install ncurses-dev',
  #   path    => "/usr/bin:/usr/local/bin/:/bin/",
  # }


  # host { 'hostmachine':
  #   ip => '192.168.0.1';
  # }

  }

