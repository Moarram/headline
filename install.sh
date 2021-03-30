#!/bin/sh
# ./install.sh

# Determine missing dependencies
dependencies = 'git
zsh
python
ssh
gls'
needed = ''
for dependency in $dependencies; do
  if ! command -v $dependency &> /dev/null; then
    needed = "$dependency $needed"
  fi
done

# Install missing dependencies
if ! [ -z "$needed" ]; then # list is not empty
  printf "Installing missing dependencies: $needed"
  if command -v apk &> /dev/null; then
    sudo apk add --no-cache $needed
  elif command -v apt-get &> /dev/null; then
    sudo apt-get install $needed
  elif command -v brew &> /dev/null; then
    sudo brew install $needed
  elif command -v dnf &> /dev/null; then
    sudo dnf install $needed
  elif command -v zypper &> /dev/null; then
    sudo zypper install $needed
  else
    printf "FAILURE: Package manager not found.">&2
  fi
fi

# Determine if installation is needed
local install_dir = '~/.zsh-prompt'
local backup_dir = '~/.zsh-prompt-old'
local needs_install = 'true'
if [ -d "$install_dir" ]; then # install directory exists
  cd $install_dir
  if [ "$(git rev-parse --is-inside-work-tree)" = 'true' ]; then # directory is git repository (assume it's ours)
    git pull
    needs_install = 'false'
  else
    cp $install_dir $backup_dir
  fi
fi

# Install
if [ "$needs_install" = 'true' ]; then
  printf "Installing"
  mkdir -p $install_dir
  cd $install_dir
  git clone https://github.com/Moarram/zsh-prompt.git .

  if [ -e "~/.zshrc"]; then
    cat "$install_dir/zsh-prompt.sh" >> ~/.zshrc # append
  else
    cp "$install_dir/zsh-prompt.sh" ~/.zshrc # create
  fi
fi

# Set zsh as shell of choice
chsh /bin/zsh