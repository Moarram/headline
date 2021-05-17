#!/bin/zsh
# To install, source this file from your .zshrc file

# TODO
# configurable segments
# line or not
# line color
# float left or right
# content
# collapse or not
# collapse criteria
# conditional segments

# Prompt config options
ZSH_PROMPT_DO_LINE='auto' # yes|no|auto
ZSH_PROMPT_LINE_ACCENT_CHAR='_'
ZSH_PROMPT_LINE_FILL_CHAR='_'
# ZSH_PROMPT_USER_SYM=' '
# ZSH_PROMPT_MACHINE_SYM=' '
# ZSH_PROMPT_PATH_SYM=' '
# ZSH_PROMPT_GIT_BRANCH_SYM=' '

# Flags
! [ -z "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ]
IS_SSH=$?

# Prompt colors (0-15)
ZSH_PROMPT_COLOR_LINE=8
ZSH_PROMPT_COLOR_INPUT=15
# ZSH_PROMPT_COLOR_OUTPUT=7
ZSH_PROMPT_COLOR_JOINTS=8
ZSH_PROMPT_COLOR_USER=$(( $IS_SSH == 0 ? 13 : 9 ))
ZSH_PROMPT_COLOR_MACHINE=11
ZSH_PROMPT_COLOR_PATH=12
ZSH_PROMPT_COLOR_GIT_BRANCH=14
ZSH_PROMPT_COLOR_GIT_STATUS=13
ZSH_PROMPT_COLOR_USER_LINE=$ZSH_PROMPT_COLOR_USER
ZSH_PROMPT_COLOR_MACHINE_LINE=$ZSH_PROMPT_COLOR_MACHINE
ZSH_PROMPT_COLOR_PATH_LINE=$ZSH_PROMPT_COLOR_PATH
ZSH_PROMPT_COLOR_GIT_BRANCH_LINE=$ZSH_PROMPT_COLOR_GIT_BRANCH
ZSH_PROMPT_COLOR_GIT_STATUS_LINE=$ZSH_PROMPT_COLOR_GIT_STATUS

# Git status
RELATIVE="$(dirname ${(%):-%x})"
source "$RELATIVE/deps/zsh-prompt-git.sh"
ZSH_PROMPT_GIT_STAGED="%B+"
ZSH_PROMPT_GIT_CONFLICTS="%b✘"
ZSH_PROMPT_GIT_CHANGED="%B!"
ZSH_PROMPT_GIT_UNTRACKED="%B?"
ZSH_PROMPT_GIT_BEHIND="%b↓"
ZSH_PROMPT_GIT_AHEAD="%b↑"
ZSH_PROMPT_GIT_CLEAN=""

# Constants for zsh
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

# Logic for line 1
do_separator=1 # is set true after prompting
if [ $IS_SSH = 0 ]; then
	do_separator=0 # assume it's not a fresh window
fi
preexec() {
  # print -nrP "%F{$ZSH_PROMPT_COLOR_OUTPUT}"
  if [ "$2" = "clear" ]; then
    do_separator=1
  fi
}

# Prompt line 1 and 2
setopt PROMPT_SUBST
precmd() {
  local A=$ZSH_PROMPT_LINE_ACCENT_CHAR
  local L=$ZSH_PROMPT_LINE_FILL_CHAR

  # <branch>
  local git_branch=$(git_prompt_branch)
  local git_branch_str=""
  if ! [[ -z $git_branch ]]; then
    git_branch_str="%B%F{$ZSH_PROMPT_COLOR_GIT_BRANCH}$ZSH_PROMPT_GIT_BRANCH_SYM$git_branch"
  fi
  prompt_len $git_branch_str
  local -i git_branch_str_len=$REPLY
  local git_branch_line="%B%F{$ZSH_PROMPT_COLOR_GIT_BRANCH_LINE}${(l:(( $git_branch_str_len * 2 ))::$A:)}"

  # <status>
  local git_status_str="%B%F{$ZSH_PROMPT_COLOR_GIT_STATUS}$(git_prompt_status)"
  prompt_len $git_status_str
  local -i git_status_str_len=$REPLY
  local git_status_line="%B%F{$ZSH_PROMPT_COLOR_GIT_STATUS_LINE}${(l:(( $git_status_str_len * 2 ))::$A:)}"

  # [<status>]
  if [ $git_status_str_len -gt 0 ]; then
    git_status_str_len=$(( $git_status_str_len + 3 ))
    git_status_str=" %b%F{$ZSH_PROMPT_COLOR_JOINTS}[$git_status_str%b%F{$ZSH_PROMPT_COLOR_JOINTS}]"
    git_status_line="%b%F{$ZSH_PROMPT_COLOR_LINE}$L$L$git_status_line%b%F{$ZSH_PROMPT_COLOR_LINE}$L"
  fi

  # <branch> (<status>)
  local git_str_len=$(( $git_branch_str_len + $git_status_str_len ))
  local git_str="$git_branch_str$git_status_str"
  local git_line="$git_branch_line$git_status_line"

  # username
  local user_name=$USER
  prompt_len $user_name
  local -i user_name_len=$REPLY

  # hostname
  local host_name=$(hostname -s)
  prompt_len $host_name
  local -i host_name_len=$REPLY

  # cropping
  if (( $user_name_len + $host_name_len + 3 > $COLUMNS / 3 || $COLUMNS < 40 )); then
    user_name="${user_name:0:1}"
    host_name="${host_name:0:1}"
  fi

  # <user> @
  local user_str="%B%F{$ZSH_PROMPT_COLOR_USER}$ZSH_PROMPT_USER_SYM$user_name%b %F{$ZSH_PROMPT_COLOR_JOINTS}@ " # %B
  prompt_len $user_str
  local -i user_str_len=$REPLY
  local user_line="%B%F{$ZSH_PROMPT_COLOR_USER_LINE}${(r:(( $user_str_len * 2 - 6 ))::$A:)}%b%F{$ZSH_PROMPT_COLOR_LINE}$L$L$L"

  # <machine>:
  local machine_str="%B%F{$ZSH_PROMPT_COLOR_MACHINE}$ZSH_PROMPT_MACHINE_SYM$host_name%b%F{$ZSH_PROMPT_COLOR_JOINTS}: " # %B
  prompt_len $machine_str
  local -i machine_str_len=$REPLY
  local machine_line="%B%F{$ZSH_PROMPT_COLOR_MACHINE_LINE}${(r:(( $machine_str_len * 2 - 4 ))::$A:)}%b%F{$ZSH_PROMPT_COLOR_LINE}$L$L"

  # <path>
  local remainder_len=$(( $COLUMNS - $user_str_len - $machine_str_len - ($git_str_len ? ($git_str_len + 3) : 0) ))
  local path_str="%B%F{$ZSH_PROMPT_COLOR_PATH}$ZSH_PROMPT_PATH_SYM%$remainder_len<...<%~%<<%b" # %B
  prompt_len $path_str
  local -i path_str_len=$REPLY
  local path_line="%B%F{$ZSH_PROMPT_COLOR_PATH_LINE}${(l:(( $path_str_len * 2 ))::$A:)}"

  # padding
  local spaces=$(( $COLUMNS - $user_str_len - $machine_str_len - $path_str_len - $git_str_len ))
  local pad=${(l:$spaces:: :)}
  local pad_line="%b%F{$ZSH_PROMPT_COLOR_LINE}${(l:(( $spaces * 2 ))::$L:)}"
  if (( $git_str_len > 0 )) && (( $spaces < 4 )); then
    pad=" %F{$ZSH_PROMPT_COLOR_JOINTS}| "
    pad_line="%b%F{$ZSH_PROMPT_COLOR_LINE}$L$L$L"
  fi

  # _____
  if [[ $ZSH_PROMPT_DO_LINE == 'yes' || ($ZSH_PROMPT_DO_LINE == 'auto' && $do_separator == 0 ) ]]; then
    print -rP "$user_line$machine_line$path_line$pad_line$git_line"
  fi
  do_separator=0

  # <user> @ <machine>: <path>  padding  <branch> [<status>]
  print -rP "$user_str$machine_str$path_str$pad$git_str" # information line
}

# Prompt line 3
PROMPT="%F{$ZSH_PROMPT_COLOR_INPUT}%(#.#.%(!.!.$)) "
PROMPT_EOL_MARK=""
