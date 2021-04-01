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
ZSH_PROMPT_SEP_ALL=1 # false

# Prompt colors (0-15)
COLOR_LINE=8
COLOR_INPUT=15
COLOR_OUTPUT=7
COLOR_FAINT=8
COLOR_USER=$(( $IS_SSH == 0 ? 13 : 9 ))
COLOR_MACHINE=11
COLOR_PATH=12
COLOR_GIT_BRANCH=14
COLOR_GIT_STATUS=9
COLOR_USER_LINE=$(( $COLOR_USER - 0 ))
COLOR_MACHINE_LINE=$(( $COLOR_MACHINE - 0 ))
COLOR_PATH_LINE=$(( $COLOR_PATH - 0 ))
COLOR_GIT_BRANCH_LINE=$(( $COLOR_GIT_BRANCH - 0 ))
COLOR_GIT_STATUS_LINE=$(( $COLOR_GIT_STATUS - 0 ))

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
  local L='_' # line spacer char
  local A='_' # line accent char

  # <branch>
  local git_branch_str="%B%F{$COLOR_GIT_BRANCH}$(git_prompt_branch)"
  prompt_len $git_branch_str
  local -i git_branch_str_len=$REPLY
  local git_branch_line="%B%F{$COLOR_GIT_BRANCH_LINE}${(l:(( $git_branch_str_len * 2 ))::$A:)}"

  # <status>
  local git_status_str="%B%F{$COLOR_GIT_STATUS}$(git_prompt_status)"
  prompt_len $git_status_str
  local -i git_status_str_len=$REPLY
  local git_status_line="%B%F{$COLOR_GIT_STATUS_LINE}${(l:(( $git_status_str_len * 2 ))::$A:)}"

  # (<status>)
  if [ $git_status_str_len -gt 0 ]; then
    git_status_str_len=$(( $git_status_str_len + 3 ))
    git_status_str=" %b%F{$COLOR_FAINT}($git_status_str%b%F{$COLOR_FAINT})"
    git_status_line="%b%F{$COLOR_LINE}$L$L$git_status_line%b%F{$COLOR_LINE}$L"
  fi

  # <branch> (<status>)
  local git_str_len=$(( $git_branch_str_len + $git_status_str_len ))
  local git_str="$git_branch_str$git_status_str"
  local git_line="$git_branch_line$git_status_line"

  # <user> @
  local user_str="%B%F{$COLOR_USER}%n%b %F{$COLOR_FAINT}@ " # %B
  prompt_len $user_str
  local -i user_str_len=$REPLY
  local user_line="%B%F{$COLOR_USER_LINE}${(r:(( $user_str_len * 2 - 6 ))::$A:)}%b%F{$COLOR_LINE}$L$L$L"

  # <machine>:
  local machine_str="%B%F{$COLOR_MACHINE}%m%b%F{$COLOR_FAINT}: " # %B
  prompt_len $machine_str
  local -i machine_str_len=$REPLY
  local machine_line="%B%F{$COLOR_MACHINE_LINE}${(r:(( $machine_str_len * 2 - 4 ))::$A:)}%b%F{$COLOR_LINE}$L$L"

  # <path>
  local remainder_len=$(( $COLUMNS - $user_str_len - $machine_str_len - ($git_str_len ? ($git_str_len + 3) : 0) ))
  local path_str="%B%F{$COLOR_PATH}%$remainder_len<...<%~%<<%b" # %B
  prompt_len $path_str
  local -i path_str_len=$REPLY
  local path_line="%B%F{$COLOR_PATH_LINE}${(l:(( $path_str_len * 2 ))::$A:)}"

  # padding
  local spaces=$(( $COLUMNS - $user_str_len - $machine_str_len - $path_str_len - $git_str_len ))
  local pad=${(l:$spaces:: :)}
  local pad_line="%b%F{$COLOR_LINE}${(l:(( $spaces * 2 ))::$L:)}"
  if (( $git_str_len > 0 )) && (( $spaces < 4 )); then
    pad=" %F{$COLOR_FAINT}| "
    pad_line="%b%F{$COLOR_LINE}$L$L$L"
  fi

  # _________________________________________
  if [ "$do_separator" = 0 ] || [ "$ZSH_PROMPT_SEP_ALL" = 0 ]; then
    print -rP "$user_line$machine_line$path_line$pad_line$git_line"
    # print -rP "%F{$COLOR_LINE}${(l:$COLUMNS::_:)}"
  fi
  do_separator=0

  # <user> @ <machine>: <path>  padding  <branch> (<status>)
  print -rP "$user_str$machine_str$path_str$pad$git_str" # information line
}

# Prompt line 3
PROMPT="%F{$COLOR_INPUT}$ "
PROMPT_EOL_MARK=""
