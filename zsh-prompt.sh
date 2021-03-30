#!/bin/zsh
# To install, source this file from your .zshrc file

# Constants
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
unsetopt PROMPT_SP

# Completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix
autoload -Uz compinit && compinit
setopt MENU_COMPLETE

# Prompt length calculator
prompt_len() {
  emulate -L zsh
  local -i COLUMNS=${2:-COLUMNS}
  local -i x y=${#1} m
  if (( y )); then
    while (( ${${(%):-$1%$y(l.1.0)}[-1]} )); do
    x=y
    (( y *= 2 ))
    done
    while (( y > x + 1 )); do
    (( m = x + (y - x) / 2 ))
    (( ${${(%):-$1%$m(l.x.y)}[-1]} = m ))
    done
  fi
  typeset -g REPLY=$x
}

# Prompt colors (0-15)
COLOR_LINE=8
COLOR_FAINT=8
COLOR_USER=9 # 3
COLOR_MACHINE=11
COLOR_PATH=12
COLOR_GIT_BRANCH=14
COLOR_GIT_STATUS=9

# Git status
source ~/.zsh-prompt/deps/zshrc_git.sh
ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX="%b%F{$COLOR_FAINT})"
ZSH_THEME_GIT_PROMPT_SEPARATOR=" %b%F{$COLOR_FAINT}(%F{$COLOR_GIT_STATUS}"
ZSH_THEME_GIT_PROMPT_BRANCH="%B%F{$COLOR_GIT_BRANCH}" # %B
ZSH_THEME_GIT_PROMPT_STAGED="%B+" # %B
ZSH_THEME_GIT_PROMPT_CONFLICTS="%b✘"
ZSH_THEME_GIT_PROMPT_CHANGED="%B!" # %B
# ZSH_THEME_GIT_PROMPT_BEHIND="%B↓" # %B
# ZSH_THEME_GIT_PROMPT_AHEAD="%B↑" # %B
ZSH_THEME_GIT_PROMPT_UNTRACKED="%B?" # %B
# ZSH_THEME_GIT_PROMPT_CLEAN="%b✔"

# Logic for line 1
do_separator=0 # is set true after prompting
preexec() {
  if [ "$2" = "clear" ]; then
    do_separator=0
  fi
}

# Prompt line 1 and 2
setopt PROMPT_SUBST
precmd() {
  local git_str=$(git_super_status) # see variables ZSH_THEME_GIT_PROMPT_...
  prompt_len $git_str
  local -i git_str_len=$REPLY

  local user_str="%B%F{$COLOR_USER}%n%b %F{$COLOR_FAINT}@ " # %B
  prompt_len $user_str
  local -i user_str_len=$REPLY

  local machine_str="%B%F{$COLOR_MACHINE}%m%b%F{$COLOR_FAINT}:%f " # %B
  prompt_len $machine_str
  local -i machine_str_len=$REPLY

  local remainder_len=$(( $COLUMNS - $user_str_len - $machine_str_len - ($git_str_len ? ($git_str_len + 3) : 0) ))
  local path_str="%B%F{$COLOR_PATH}%$remainder_len<...<%~%<<%b" # %B
  prompt_len $path_str
  local -i path_str_len=$REPLY

  local spaces=$(( $COLUMNS - $user_str_len - $machine_str_len - $path_str_len - $git_str_len ))
  local pad=${(l:$spaces:: :)}
  if (( $git_str_len > 0 )) && (( $spaces < 4 )); then
    pad=" %F{$COLOR_FAINT}| "
  fi

  if [ "$do_separator" -ne "0" ]; then
    print -rP "%F{$COLOR_LINE}${(r:$COLUMNS::_:)}" # separator line
  fi
  do_separator=1

  print -rP $user_str$machine_str$path_str$pad$git_str # information line
}

# Prompt line 3
PROMPT="$ "
PROMPT_EOL_MARK=""