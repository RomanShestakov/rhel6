#!/usr/bin/env bash

echo 'starting docker install'

# The username to add to the docker group will be passed as the first argument
# to the script. If nothing is passed, default to "vagrant".
user="$1"
if [ -z "$user" ]; then
user=vagrant
fi

# Enable memory cgroup and swap accounting
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/g' /etc/default/grub
update-grub

# Adding an apt gpg key is idempotent.
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9

# Creating the docker.list file is idempotent, but it may overwrite desired
# settings if it already exists. This could be solved with md5sum but it
# doesn't seem worth it.
echo 'deb http://get.docker.io/ubuntu docker main' > \
/etc/apt/sources.list.d/docker.list

# Update remote package metadata. 'apt-get update' is idempotent.
apt-get update -q

# Install docker. 'apt-get install' is idempotent.
apt-get install -q -y lxc-docker

usermod -a -G docker "$user"

tmp=`mktemp -q` && {
# Only install the backport kernel, don't bother upgrading if the backport is
# already installed. We want parse the output of apt so we need to save it
# with 'tee'. NOTE: The installation of the kernel will trigger dkms to
# install vboxguest if needed.
apt-get install -q -y --no-upgrade linux-image-generic-lts-raring | \
tee "$tmp"

# Parse the number of installed packages from the output
NUM_INST=`awk '$2 == "upgraded," && $4 == "newly" { print $3 }' "$tmp"`
rm "$tmp"
}

# # If the number of installed packages is greater than 0, we want to reboot (the
# # backport kernel was installed but is not running).
# if [ "$NUM_INST" -gt 0 ];
# then
# echo "Rebooting down to activate new kernel."
# echo "/vagrant will not be mounted. Use 'vagrant halt' followed by"
# echo "'vagrant up' to ensure /vagrant is mounted."
# shutdown -r now
# fi

# if [ ! -d /opt/VBoxGuestAdditions-4.3.6/ ]; then
# # Update remote package metadata. 'apt-get update' is idempotent.
# apt-get update -q

# # Kernel Headers and dkms are required to build the vbox guest kernel
# # modules.
# apt-get install -q -y linux-headers-generic-lts-raring dkms

# echo 'Downloading VBox Guest Additions...'
# wget -cq http://dlc.sun.com.edgesuite.net/virtualbox/4.3.6/VBoxGuestAdditions_4.3.6.iso
# echo "95648fcdb5d028e64145a2fe2f2f28c946d219da366389295a61fed296ca79f0 VBoxGuestAdditions_4.3.6.iso" | sha256sum --check || exit 1

# mount -o loop,ro /home/vagrant/VBoxGuestAdditions_4.3.6.iso /mnt
# /mnt/VBoxLinuxAdditions.run --nox11
# umount /mnt
# fi
