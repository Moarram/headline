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

# Flags
! [ -z "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ]
IS_SSH=$?

# Prompt colors (0-15)
COLOR_LINE=8
COLOR_OUTPUT=15
COLOR_FAINT=8
COLOR_USER=9 # 3
if [ $IS_SSH = 0 ]; then COLOR_USER=13; fi
COLOR_MACHINE=11
COLOR_PATH=12
COLOR_GIT_BRANCH=14
COLOR_GIT_STATUS=9

# Git status
source ~/.zsh-prompt/deps/zshrc_git.sh
ZSH_THEME_GIT_PROMPT_STAGED="%B+" # %B
ZSH_THEME_GIT_PROMPT_CONFLICTS="%b✘"
ZSH_THEME_GIT_PROMPT_CHANGED="%B!" # %B
ZSH_THEME_GIT_PROMPT_UNTRACKED="%B?" # %B

# Logic for line 1
do_separator=1 # is set true after prompting
if [ $IS_SSH = 0 ]; then
	do_separator=0 # assume it's not a fresh window
fi
preexec() {
  print -nrP "%F{$COLOR_OUTPUT}"
  if [ "$2" = "clear" ]; then
    do_separator=1
  fi
}

# Prompt line 1 and 2
setopt PROMPT_SUBST
precmd() {
  # <branch>
  local git_branch_str="%F{$COLOR_GIT_BRANCH}$(git_prompt_branch)"
  prompt_len $git_branch_str
  local -i git_branch_str_len=$REPLY
  local git_branch_line="%B%F{$COLOR_GIT_BRANCH}${(r:$git_branch_str_len::_:)}"

  # <status>
  local git_status_str="%B%F{$COLOR_GIT_STATUS}$(git_prompt_status)"
  prompt_len $git_status_str
  local -i git_status_str_len=$REPLY
  local git_status_line="%B%F{$COLOR_GIT_STATUS}${(r:$git_status_str_len::_:)}"

  # (<status>)
  if [ $git_status_str_len -gt 0 ]; then
    git_status_str_len=$(( $git_status_str_len + 3 ))
    git_status_str=" %b%F{$COLOR_FAINT}($git_status_str%b%F{$COLOR_FAINT})"
    git_status_line="%b%F{$COLOR_LINE}__$git_status_line%b%F{$COLOR_LINE}_"
  fi

  # <branch> (<status>)
  local git_str_len=$(( $git_branch_str_len + $git_status_str_len ))
  local git_str="$git_branch_str$git_status_str"
  local git_line="$git_branch_line$git_status_line"

  # <user> @
  local user_str="%B%F{$COLOR_USER}%n%b %F{$COLOR_FAINT}@ " # %B
  prompt_len $user_str
  local -i user_str_len=$REPLY
  local user_line="%B%F{$COLOR_USER}${(r:(( $user_str_len - 3 ))::_:)}%b%F{$COLOR_LINE}___"

  # <machine>:
  local machine_str="%B%F{$COLOR_MACHINE}%m%b%F{$COLOR_FAINT}: " # %B
  prompt_len $machine_str
  local -i machine_str_len=$REPLY
  local machine_line="%B%F{$COLOR_MACHINE}${(r:(( $machine_str_len - 2 ))::_:)}%b%F{$COLOR_LINE}__"

  # <path>
  local remainder_len=$(( $COLUMNS - $user_str_len - $machine_str_len - ($git_str_len ? ($git_str_len + 3) : 0) ))
  local path_str="%B%F{$COLOR_PATH}%$remainder_len<...<%~%<<%b" # %B
  prompt_len $path_str
  local -i path_str_len=$REPLY
  local path_line="%B%F{$COLOR_PATH}${(r:$path_str_len::_:)}"

  # padding
  local spaces=$(( $COLUMNS - $user_str_len - $machine_str_len - $path_str_len - $git_str_len ))
  local pad=${(l:$spaces:: :)}
  local pad_line="%b%F{$COLOR_LINE}${(r:$spaces::_:)}"
  if (( $git_str_len > 0 )) && (( $spaces < 4 )); then
    pad=" %F{$COLOR_FAINT}| "
    pad_line="%b%F{$COLOR_LINE}___"
  fi

  # ____
  if [ "$do_separator" = 0 ]; then
    print -rP "$user_line$machine_line$path_line$pad_line$git_line"
    # print -rP "%F{$COLOR_LINE}${(r:$COLUMNS::_:)}"
  fi
  do_separator=0

  # <user> @ <machine>: <path>  padding  <branch> (<status>)
  print -rP "$user_str$machine_str$path_str$pad$git_str" # information line
}

# Prompt line 3
PROMPT="%f$ "
PROMPT_EOL_MARK=""
