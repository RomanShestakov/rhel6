# -*- mode: puppet-mode -*-
# vi: set ft=ruby :


# install emacs from pre-compiled source
# modeled from here : https://github.com/finitud/vagrant-common-lisp/blob/master/private/puppet/manifests/base.pp

class emacs( $version = 'emacs24', $username = 'emacs' ) {
  $group = $username
    
  notice( "running emacs install under user: $username..." )

  if !defined(Package['curl']) {
    package{'curl':
      ensure => present,
    }
  }

  # magit mode in emacs depends on makeinfo, so need texinfo pkg
  if !defined(Package['texinfo']) {
    package{'texinfo':
      ensure => present,
    }
  }

  # distel mode in emacs depends on texlive
  if !defined(Package['texlive']) {
    package{'texlive':
      ensure => present,
    }
  }

  # el-get needs bzr to install python-mode
  if !defined(Package['bzr']) {
    package{'bzr':
      ensure => present,
    }
  }

  # group { $username:
  #   ensure => present,
  #   gid    => 2100,
  # }
  
  # user{ $username :
  #   ensure     => present,
  #   gid        => $group,
  #   require    => Group[ $group ],
  #   uid        => 2100,
  #   home       => "/home/${username}",
  #   shell      => "/bin/bash",
  #   managehome => true,
  # }
  
  exec { 'initial update':
    command => '/usr/bin/apt-get -y update',
    path    => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
  }
  
  package{ ['python-software-properties']:
    ensure => present,
    require => Exec[ 'initial update' ],
  }

  # package{ ['curl', 'python-software-properties']:
  #   ensure => present,
  #   require => Exec[ 'initial update' ],
  # }

 if $version == 'emacs24' {
  exec { 'add emacs repository':
    command => 'add-apt-repository ppa:cassou/emacs -y',
    path    => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
    require => Package[ 'python-software-properties' ],
  }
  
  exec { 'second update':
    command => 'apt-get -y update',
    path    => "/sbin:/usr/bin:/usr/local/bin/:/bin/",
    require => Exec[ 'add emacs repository' ],
  }
  
  package{ [ 'emacs24', 'emacs24-el', 'emacs24-common-non-dfsg', 'sbcl', 'sbcl-doc', 'sbcl-source', ]:
    ensure => present,
    require => Exec[ 'second update' ],
  }
 }
 else {
   package{ ['emacs23'] :
     ensure => present,
   }
 }
 
   
  file { "/home/$username/.emacs.d":
    path => "/home/$username/.emacs.d",
    ensure => 'directory',
    owner => $username,
    mode => '755',
  }
  
  vcsrepo{ "/home/$username/.emacs.d":
    ensure => latest,
    provider => git,
    source => 'https://github.com/RomanShestakov/.emacs.d',
    revision => 'master',
    require => [ File[ "/home/$username/.emacs.d" ] ],
  }
}
