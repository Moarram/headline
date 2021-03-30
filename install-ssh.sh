#!/bin/sh
# ./install-ssh.sh <destination> [optional ssh args]

# check existence and version of zsh-prompt
# install if needed
# call ssh with args

local destination = $2
shift 2 # remove $1 and $2

printf "Transfer install script to remote machine"
scp "$@" install.sh $destination:/tmp/install-zsh-prompt.sh # transfer install script

printf "Run install script on remote machine"
ssh "$@" -t $destination "sudo chmod +x /tmp/install-zsh-prompt.sh && sudo /tmp/install-zsh-prompt.sh" # run install script

printf "Login to remote machine"
ssh "$@" $destination
