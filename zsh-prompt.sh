#!/bin/zsh
# To install, source this file from your .zshrc file

# Prompt config options
DO_LINE='auto' # yes|no|auto
CHAR_LINE_ACCENT='_'
CHAR_LINE_FILL='_'
# SYM_USER=' '
# SYM_MACHINE=' '
# SYM_PATH=' '
# SYM_GIT_BRANCH=' '

# Flags
! [ -z "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ]
IS_SSH=$?

# Formatting aliases
reset=$'\e[0m'
bold=$'\e[1m'
faint=$'\e[2m'
italic=$'\e[3m'
underline=$'\e[4m'
invert=$'\e[7m'
# ...

# Foreground color aliases
black=$'\e[30m'
red=$'\e[31m'
green=$'\e[32m'
yellow=$'\e[33m'
blue=$'\e[34m'
magenta=$'\e[35m'
cyan=$'\e[36m'
white=$'\e[37m'
light_black=$'\e[90m'
light_red=$'\e[91m'
light_green=$'\e[92m'
light_yellow=$'\e[93m'
light_blue=$'\e[94m'
light_magenta=$'\e[95m'
light_cyan=$'\e[96m'
light_white=$'\e[97m'

# Background color aliases
black_back=$'\e[40m'
red_back=$'\e[41m'
green_back=$'\e[42m'
yellow_back=$'\e[43m'
blue_back=$'\e[44m'
magenta_back=$'\e[45m'
cyan_back=$'\e[46m'
white_back=$'\e[47m'
light_black_back=$'\e[100m'
light_red_back=$'\e[101m'
light_green_back=$'\e[102m'
light_yellow_back=$'\e[103m'
light_blue_back=$'\e[104m'
light_magenta_back=$'\e[105m'
light_cyan_back=$'\e[106m'
light_white_back=$'\e[107m'

# Styles
STYLE_DEFAULT="" # optional style applied to each part
STYLE_LINE=$light_black
STYLE_JOINTS=$light_black
STYLE_JOINTS_LINE=$light_black
if [ $IS_SSH = 0 ]; then
  STYLE_USER=$bold$magenta
  STYLE_USER_LINE=$STYLE_USER
else
  STYLE_USER=$bold$red
  STYLE_USER_LINE=$STYLE_USER
fi
STYLE_MACHINE=$bold$yellow
STYLE_MACHINE_LINE=$STYLE_MACHINE
STYLE_PATH=$bold$blue
STYLE_PATH_LINE=$STYLE_PATH
STYLE_GIT_BRANCH=$bold$cyan
STYLE_GIT_BRANCH_LINE=$STYLE_GIT_BRANCH
STYLE_GIT_STATUS=$bold$magenta
STYLE_GIT_STATUS_LINE=$STYLE_GIT_STATUS

# Git status
RELATIVE="$(dirname ${(%):-%x})"
source "$RELATIVE/deps/zsh-prompt-git.sh"
ZSH_PROMPT_GIT_STAGED="+"
ZSH_PROMPT_GIT_CONFLICTS="✘"
ZSH_PROMPT_GIT_CHANGED="!"
ZSH_PROMPT_GIT_UNTRACKED="?"
ZSH_PROMPT_GIT_BEHIND="↓"
ZSH_PROMPT_GIT_AHEAD="↑"
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
  if [ "$2" = "clear" ]; then
    do_separator=1
  fi
}

# Prompt line 1 and 2
setopt PROMPT_SUBST
precmd() {
  # Prepend each style with reset and default styles
  local S_LINE=$reset$STYLE_LINE
  for part in USER MACHINE PATH GIT_BRANCH GIT_STATUS JOINTS; do
    eval local S_${part}="\$reset\$STYLE_DEFAULT\$STYLE_${part}"
    eval local S_${part}_LINE="\$reset\$STYLE_${part}_LINE"
  done

  # Aliases
  local A=$CHAR_LINE_ACCENT
  local L=$CHAR_LINE_FILL

  # <branch>
  local git_branch=$(git_prompt_branch)
  local git_branch_str=""
  if ! [[ -z $git_branch ]]; then
    git_branch_str="%{$S_GIT_BRANCH%}$SYM_GIT_BRANCH$git_branch"
  fi
  prompt_len $git_branch_str
  local -i git_branch_str_len=$REPLY
  local git_branch_line="%{$S_GIT_BRANCH_LINE%}${(l:(( $git_branch_str_len * 2 ))::$A:)}"

  # <status>
  local git_status_str="%{$S_GIT_STATUS%}$(git_prompt_status)"
  prompt_len $git_status_str
  local -i git_status_str_len=$REPLY
  local git_status_line="%{$S_GIT_STATUS_LINE%}${(l:(( $git_status_str_len * 2 ))::$A:)}"

  # [<status>]
  if [ $git_status_str_len -gt 0 ]; then
    git_status_str_len=$(( $git_status_str_len + 3 ))
    git_status_str="%{$S_JOINTS%} [$git_status_str%{$S_JOINTS%}]"
    git_status_line="%{$S_JOINTS_LINE%}$L$L$git_status_line%{$S_JOINTS_LINE%}$L"
  fi

  # <branch> (<status>)
  local git_str_len=$(( $git_branch_str_len + $git_status_str_len ))
  local git_str="$git_branch_str$git_status_str"
  local git_line="$git_branch_line$git_status_line"

  # Username
  local user_name=$USER
  prompt_len $user_name
  local -i user_name_len=$REPLY

  # Hostname
  local host_name=$(hostname -s)
  prompt_len $host_name
  local -i host_name_len=$REPLY

  # Cropping
  if (( $user_name_len + $host_name_len + 3 > $COLUMNS / 3 || $COLUMNS < 40 )); then
    user_name="${user_name:0:1}"
    host_name="${host_name:0:1}"
  fi

  # <user> @
  local user_str="%{$S_USER%}$SYM_USER$user_name%{$S_JOINTS%} @ "
  prompt_len $user_str
  local -i user_str_len=$REPLY
  local user_line="%{$S_USER_LINE%}${(r:(( $user_str_len * 2 - 6 ))::$A:)}%{$S_JOINTS_LINE%}$L$L$L"

  # <machine>:
  local machine_str="%{$S_MACHINE%}$SYM_MACHINE$host_name%{$S_JOINTS%}: "
  prompt_len $machine_str
  local -i machine_str_len=$REPLY
  local machine_line="%{$S_MACHINE_LINE%}${(r:(( $machine_str_len * 2 - 4 ))::$A:)}%{$S_JOINTS_LINE%}$L$L"

  # <path>
  local remainder_len=$(( $COLUMNS - $user_str_len - $machine_str_len - ($git_str_len ? ($git_str_len + 3) : 0) ))
  local path_str="%{$S_PATH%}$SYM_PATH%$remainder_len<...<%~%<<%b"
  prompt_len $path_str
  local -i path_str_len=$REPLY
  local path_line="%{$S_PATH_LINE%}${(l:(( $path_str_len * 2 ))::$A:)}"

  # Padding
  local spaces=$(( $COLUMNS - $user_str_len - $machine_str_len - $path_str_len - $git_str_len ))
  local pad="%{$S_JOINTS%}${(l:$spaces:: :)}"
  local pad_line="%{$S_LINE%}${(l:(( $spaces * 2 ))::$L:)}"
  if (( $git_str_len > 0 )) && (( $spaces < 4 )); then
    pad=" %{$S_JOINTS%}| "
    pad_line="%{$S_JOINTS_LINE%}$L$L$L"
  fi

  # _____
  if [[ $DO_LINE == 'yes' || ($DO_LINE == 'auto' && $do_separator == 0 ) ]]; then
    print -rP "$user_line$machine_line$path_line$pad_line$git_line$reset"
  fi
  do_separator=0

  # <user> @ <machine>: <path>  padding  <branch> [<status>]
  print -rP "$user_str$machine_str$path_str$pad$git_str$reset"
}

# Prompt line 3
PROMPT="%(#.#.%(!.!.$)) "
PROMPT_EOL_MARK=""
