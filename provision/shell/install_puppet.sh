#!/bin/bash

# #http://blog.doismellburning.co.uk/2013/01/19/upgrading-puppet-in-vagrant-boxes/
# https://wiki.dlib.indiana.edu/display/VarVideo/Manual+Puppet+Install

$(which apt-get > /dev/null 2>&1)
FOUND_APT=$?
$(which yum > /dev/null 2>&1)
FOUND_YUM=$?

if [ "${FOUND_YUM}" -eq '0' ]; then
    echo "Downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"
    # wget https://yum.puppetlabs.com/el/6/products/i386/puppetlabs-release-6-7.noarch.rpm
    yum -y --nogpgcheck install "http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm"
    echo "Finished downloading http://yum.puppetlabs.com/el/6/products/x86_64/puppetlabs-release-6-10.noarch.rpm"
    
    echo "Running update-puppet yum update"
    yum -y update
    echo "Finished running update-puppet yum update"
    
    echo "Installing/Updating Puppet to latest version"
    yum -y install puppet
    PUPPET_VERSION=$(puppet help | grep 'Puppet v')
    echo "Finished installing/updating puppet to latest version: ${PUPPET_VERSION}"
    
    # touch /.puphpet-stuff/update-puppet
    # echo "Created empty file /.puphpet-stuff/update-puppet"

elif [ "${FOUND_APT}" -eq '0' ]; then
    apt-get install --yes lsb-release
    DISTRIB_CODENAME=$(lsb_release --codename --short)
    DEB="puppetlabs-release-${DISTRIB_CODENAME}.deb"
    DEB_PROVIDES="/etc/apt/sources.list.d/puppetlabs.list" # Assume that this file's existence means we have the Puppet Labs repo added

    if [ ! -e $DEB_PROVIDES ]
    then
        # Print statement useful for debugging, but automated runs of this will interpret any output as an error
        # print "Could not find $DEB_PROVIDES - fetching and installing $DEB"
        wget -q http://apt.puppetlabs.com/$DEB
        sudo dpkg -i $DEB
    fi
    sudo apt-get update
    sudo apt-get install --yes puppet
fi


# VAGRANT_CORE_FOLDER=$(cat "/.puphpet-stuff/vagrant-core-folder.txt")

# OS=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" ID)
# RELEASE=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" RELEASE)
# CODENAME=$(/bin/bash "${VAGRANT_CORE_FOLDER}/shell/os-detect.sh" CODENAME)

# if [[ ! -f /.puphpet-stuff/update-puppet ]]; then
#     if [ "${OS}" == 'debian' ] || [ "${OS}" == 'ubuntu' ]; then
#         echo "Downloading http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"
#         wget --quiet --tries=5 --connect-timeout=10 -O "/.puphpet-stuff/puppetlabs-release-${CODENAME}.deb" "http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"
#         echo "Finished downloading http://apt.puppetlabs.com/puppetlabs-release-${CODENAME}.deb"

#         dpkg -i "/.puphpet-stuff/puppetlabs-release-${CODENAME}.deb" >/dev/null

#         echo "Running update-puppet apt-get update"
#         apt-get update >/dev/null
#         echo "Finished running update-puppet apt-get update"

#         echo "Updating Puppet to version 3.4.3"
#         apt-get install -y puppet=3.4.3-1puppetlabs1 puppet-common=3.4.3-1puppetlabs1 >/dev/null
#         echo "Finished updating puppet to version: 3.4.3"

#         touch /.puphpet-stuff/update-puppet
#         echo "Created empty file /.puphpet-stuff/update-puppet"
#     elif [ "${OS}" == 'centos' ]; then
#         echo "Downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"
#         yum -y --nogpgcheck install "http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm" >/dev/null
#         echo "Finished downloading http://yum.puppetlabs.com/el/${RELEASE}/products/x86_64/puppetlabs-release-6-7.noarch.rpm"

#         echo "Running update-puppet yum update"
#         yum -y update >/dev/null
#         echo "Finished running update-puppet yum update"

#         echo "Installing/Updating Puppet to latest version"
#         yum -y install puppet >/dev/null
#         PUPPET_VERSION=$(puppet help | grep 'Puppet v')
#         echo "Finished installing/updating puppet to latest version: ${PUPPET_VERSION}"

#         touch /.puphpet-stuff/update-puppet
#         echo "Created empty file /.puphpet-stuff/update-puppet"
#     fi
# fi
