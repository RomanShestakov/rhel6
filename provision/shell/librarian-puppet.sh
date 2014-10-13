#!/usr/bin/env bash

if [[ $# -eq 0 ]] ; then
    echo 'no arguments supplied'
    exit 1
fi

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR="$1"

echo "$1"

# NB: librarian-puppet might need git installed. If it is not already installed
# in your basebox, this will manually install it at this point using apt or yum

$(which apt-get > /dev/null 2>&1)
FOUND_APT=$?
$(which yum > /dev/null 2>&1)
FOUND_YUM=$?

if [ "${FOUND_YUM}" -eq '0' ]; then
    yum -q -y update
    yum -q -y makecache
    yum -q -y install build-essential
    yum -q -y install git
    # sudo rpm -ivh http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-7.noarch.rpm
    # sudo rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm
    # sudo rpm -ivh http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

    # # http://cgit.drupalcode.org/vm/tree/puphpet/shell/update-puppet.sh?id=25a9dafa8f63115d7b6ca414c117b834aede97b4
    # echo "Downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"
    # yum -y --nogpgcheck install "http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm" >/dev/null
    # echo "Finished downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"

    # echo "Running update-puppet yum update"
    # yum -y update >/dev/null
    # echo "Finished running update-puppet yum update"
    # echo "Installing/Updating Puppet to latest version"
    # sudo yum -q -y install puppet
    #PUPPET_VERSION=$(puppet help | grep 'Puppet v')
    #echo "Finished installing/updating puppet to latest version: ${PUPPET_VERSION}"
    # touch /.puphpet-stuff/update-puppet
    # echo "Created empty file /.puphpet-stuff/update-puppet"
    #yum -q -y install puppet
    #echo 'git installed.'
elif [ "${FOUND_APT}" -eq '0' ]; then
    apt-get -q -y update
    apt-get -q -y install build-essential
    apt-get -q -y install git
    apt-get -q -y istall puppet
    #echo 'git installed.'
else
    echo 'No package installer available. You may need to install git manually.'
fi

if [ "$(gem search -i librarian-puppet)" = "false" ]; then
    #intalling open3_backport separate as librarian-puppet fails 
    # to install automatically without it
    gem install open3_backport
    # echo 'Attempting to install librarian-puppet.'
    gem install librarian-puppet -v 1.0.3
    # gem install librarian-puppet
    echo '..installing modules with librarian-puppet'
    cd $PUPPET_DIR && librarian-puppet install --path modules
else
    cd $PUPPET_DIR && librarian-puppet update
fi
