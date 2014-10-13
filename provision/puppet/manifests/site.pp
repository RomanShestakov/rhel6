# -*- mode: puppet-mode -*-
# vi: set ft=ruby :

# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "/usr/local/bin/" ] }

# create a new run stage to ensure certain modules are included first
stage { 'pre':
  before => Stage['main']
}

# # add the baseconfig module to the new 'pre' run stage
# class { 'known_hosts':
#   stage => 'pre'
# }


# add the baseconfig module to the new 'pre' run stage
class { 'baseconfig':
  stage => 'pre'
}

# # add the baseconfig module to the new 'pre' run stage
# class { 'erlang':
#   stage => 'pre'
# }

# # add the baseconfig module to the new 'pre' run stage
# class { 'archive':
#   stage => 'pre'
# }

node default {
  
  include 'baseconfig'

  # class{ 'erlang':
  #   package_name => 'erlang'
  # }

  # Class['erlang'] -> Class['::emacs']
  # Class['erlang'] -> Class['elsa']
  # Class['erlang'] -> Class['elixir']

  # class { '::emacs':
  #   username => 'vagrant',
  #   version  => 'emacs24',
  # }

  # class { 'elsa':
  #   # erlang_manage => false
  # }

  # class { 'elasticsearch':
  #   version => '0.90.0',
  # }

  # class { 'elixir': 
  #   version => '0.13.2' }
 
  # class { 'postgre': }

 }

