# ZSH Prompt
I made a decent zsh prompt, but discovered that I couldn't use it when ssh'ing into a remote machine without installing zsh and the prompt on the remote machine. It can't be that hard to automate the setup process... right?

**NOTICE:** *This repository is only public for personal convenience at this time. The project is still in development.*

## Usage
### Download
Clone the repository.
```
git clone https://github.com/Moarram/zsh-prompt.git
cd zsh-prompt/
chmod +x install.sh install-ssh.sh
```

### Simple
If you are just interested in adding the zsh prompt to an existing zsh configuration, you don't need the installation scripts. In your `~/.zshrc` you can source the `zsh-prompt.sh` file:
```
source your/path/to/zsh-prompt.sh
```

### Install (local)
Install the prompt on the current machine.
```
./install.sh
```
This will download all necessary dependencies (including this git respository), source the prompt in `~/.zshrc`, and set zsh as the default shell. The downloaded git respository lives in `~/.zsh-prompt`. The script isn't particularily robust, so don't be surprised if you need to install dependencies or set zsh as your default shell manually.

### Install (remote)
Install the prompt on a remote machine. 
```
./install-ssh.sh <destination>
```
This tells the remote machine (specified by `<destination>`) to run the `install.sh` script, which will set up the shell and prompt automatically. At the end of the setup, the remote machine will also have a clone of this repository and thus can call these same scripts if you want to ssh in another layer. The goal is to have this work for any user, but because of dependency installation it only works for the root user right now.

## About
### Useful Commands
* `chsh -s /bin/zsh` – change current user's default shell to `zsh`

### Dependencies
* `git` – file management, installation
* `zsh` – shell
* `python` – [git prompt](https://travis-ci.org/olivierverdier/zsh-git-prompt) component
* `ssh` – remote installation (optional)