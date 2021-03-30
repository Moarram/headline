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

# if ! command -v $a >/dev/null 2>&1; then printf "miss\n"; else printf "hit\n"; fi

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
  if [ "$(git rev-parse --is-inside-work-tree)" = 'true' ]; then # directory is git repository (assume it's ours)
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

  if [ -e "$HOME/.zshrc" ]; then
    cat "$install_dir/zsh-prompt.sh" >> ~/.zshrc # append
  else
    cp "$install_dir/zsh-prompt.sh" ~/.zshrc # create
  fi
fi

# Set zsh as shell of choice
chsh /bin/zsh
