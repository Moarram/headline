#!/bin/sh
# ./install-ssh.sh <destination> [optional ssh args]
# Install zsh prompt on remote machine

destination="$1"
shift 1 # remove $1

printf "\n[1] Run install script on remote machine\n"
ssh "$@" $destination 'sh -s' < install.sh

printf "\n[2] Login to remote machine\n"
ssh "$@" $destination
