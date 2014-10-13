#!/bin/bash

#array=( 'github.com' )
HOST=$1
USERNAME=$2

#for h in "${array[@]"}
#do
    #echo $h
    ip=$(dig +short $HOST)
    ssh-keygen -R $HOST
    ssh-keygen -R $ip
    ssh-keyscan -H $ip >> /home/$USERNAME/.ssh/known_hosts
    ssh-keyscan -H $HOST >> /home/$USERNAME/.ssh/known_hosts
 #done
