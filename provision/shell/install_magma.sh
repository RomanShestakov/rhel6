#!/usr/bin/env bash

# if [ ! -f tmp/erlang-repos-added ]; then
# 	# Grab the repository package and install
#     wget http://packages.erlang-solutions.com/Erlang-solutions_1.0_all.deb
#     sudo dpkg -i erlang-solutions_1.0_all.deb

#     # Note that we've been here
#     mkdir -p tmp
#     touch tmp/erlang-repos-added

#     # Update our repository lists
#     sudo apt-get update -y

#     # Remove the package
#     rm erlang-solutions_1.0_all.deb
# fi

# # Install/update erlang
# sudo apt-get install -y erlang

# # Work around sudo removing this env variable by default
# SOCKET=$(ls -1 --sort t /tmp/ssh-*/agent.* | head -1)
# export SSH_AUTH_SOCK="${SOCKET}"

git clone git@github.com:RomanShestakov/magna /opt/code
#cd /opt/code/magma
#make
