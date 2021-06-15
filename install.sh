#!/bin/sh
# ./install.sh
# Install zsh prompt for the current user

# Determine missing dependencies
dependencies='git
zsh
python
ssh'
needed=''
for dependency in $dependencies; do
  if ! command -v $dependency >/dev/null 2>&1; then
    needed="$dependency $needed"
  fi
done

# Install missing dependencies
if ! [ -z "$needed" ]; then # list is not empty
  printf "Installing missing dependencies: $needed\n"
  if command -v apk >/dev/null 2>&1; then # apk (untested)
    sudo apk add --no-cache $needed
  elif command -v apt-get >/dev/null 2>&1; then # apt
    sudo apt-get update && sudo apt-get install -y $needed
  elif command -v brew >/dev/null 2>&1; then # brew (untested)
    sudo brew install $needed
  # ...add more package managers
  else
    printf "FAILURE: Package manager not found.\n">&2
  fi
fi

# Determine if installation is needed
install_dir="$HOME/.zsh-prompt"
backup_dir="$HOME/.zsh-prompt-old"
needs_install='true'
if [ -d "$install_dir" ]; then # install directory exists
  cd $install_dir
  if [ "$(git rev-parse --is-inside-work-tree)" 2> /dev/null = 'true' ]; then # directory is git repository (assume it's ours)
    printf "Updating zsh prompt\n"
    git pull
    needs_install='false'
  else
    cp $install_dir $backup_dir
  fi
fi

# Install
if [ "$needs_install" = 'true' ]; then
  printf "Installing zsh prompt\n"
  mkdir -p $install_dir
  git clone https://github.com/Moarram/zsh-prompt.git $install_dir
fi

# Source
if ! [ -e "$HOME/.zshrc" ]; then
  touch ~/.zshrc
fi
source_str="source $install_dir/zsh-prompt.sh"
if ! grep -q "$source_str" ~/.zshrc; then
  echo $source_str >> ~/.zshrc
fi

# Set zsh as shell of choice
if [ $SHELL != '/bin/zsh' ]; then
  chsh -s /bin/zsh $USER 2> /dev/null || sudo usermod -s /bin/zsh $USER # first way should work... but it doesn't
fi
