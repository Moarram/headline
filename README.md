# ZSH Prompt

## Download
Clone the repository.
```
git clone https://github.com/Moarram/zsh-prompt.git
cd zsh-prompt/
chmod +x install.sh install-ssh.sh
```

## Install (local)
Install the prompt on the current machine.
```
./install.sh
```

## Install (remote)
Install the prompt on a remote machine.
```
./install-ssh.sh <destination>
```

## Dependencies
`git` - file management, installation
`zsh` - shell
`python` - [git prompt](https://travis-ci.org/olivierverdier/zsh-git-prompt) component
`ssh` - remote installation (optional)