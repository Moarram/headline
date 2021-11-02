#!/bin/zsh
# To install, source this file from your .zshrc file
# Customization variables begin around line 90

# ____________________________________________________________________
# <user> @ <host>: <path>                          <branch> [<status>]
# $ git clone -b main https://github.com/Moarram/headline-zsh-theme



# Git branch and status functions
RELATIVE="$(dirname ${(%):-%x})"
GIT_STATUS_FILEPATH="$RELATIVE/deps/zsh-git-status.sh" # required for <status>, slower prompt
if [[ -e $GIT_STATUS_FILEPATH ]]; then
  source $GIT_STATUS_FILEPATH
else # branch only, no status
  autoload -Uz vcs_info
  zstyle ':vcs_info:git:*' formats '%b'
  git_prompt_branch() {
    vcs_info
    echo $vcs_info_msg_0_
  }
  git_prompt_status() { echo '' }
fi

# Constants for zsh
setopt PROMPT_SP # always start prompt on new line
setopt PROMPT_SUBST # substitutions
autoload -U add-zsh-hook

# Flags
! [ -z "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ]
IS_SSH=$?



# Formatting aliases
# (add more if you need)
reset=$'\e[0m'
bold=$'\e[1m'
faint=$'\e[2m'
italic=$'\e[3m'
underline=$'\e[4m'
invert=$'\e[7m'
# ...

# Foreground color aliases
# (dont change these definitions, apply them below)
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
# (dont change these definitions, apply them below)
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

# User defined colors
# REF: https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters
# orange_yellow=$'\e[38;5;214m' # example 8-bit color
# orange_brown=$'\e[38;2;191;116;46m' # example rgb color
# ...



# ------------------------------------------------------------------------------
# Customization
# I recommend setting these variables in your ~/.zshrc after sourcing this file
# The style aliases (defined above) can be used there too.

# Prompt config options
DO_LINE='auto' # on|auto|off

# Repeated characters (no styles here)
CHAR_LINE_ACCENT='_' # line above info parts (user, host, path, etc)
CHAR_LINE_FILL='_' # line above joints and spaces

# Decoration strings (no styles here)
JOINT_USER_BEGIN=''
PRE_USER='' # consider " "
POST_USER=''
JOINT_USER_TO_HOST=' @ '
PRE_HOST='' # consider " "
POST_HOST=''
JOINT_HOST_TO_PATH=': '
PRE_PATH='' # consider " "
POST_PATH=''
JOINT_PATH_TO_BRANCH=' | ' # used when no padding between <path> and <branch>
JOINT_PATH_TO_PAD='' # used if padding between <path> and <branch>
JOINT_PAD_TO_BRANCH='' # used if padding between <path> and <branch>
PRE_GIT_BRANCH='' # consider " "
POST_GIT_BRANCH=''
JOINT_BRANCH_TO_STATUS=' ['
PRE_GIT_STATUS=''
POST_GIT_STATUS=''
JOINT_STATUS_END=']'

# Styles
STYLE_DEFAULT='' # style applied to entire info line
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
STYLE_HOST=$bold$yellow
STYLE_HOST_LINE=$STYLE_HOST
STYLE_PATH=$bold$blue
STYLE_PATH_LINE=$STYLE_PATH
STYLE_GIT_BRANCH=$bold$cyan
STYLE_GIT_BRANCH_LINE=$STYLE_GIT_BRANCH
STYLE_GIT_STATUS=$bold$magenta
STYLE_GIT_STATUS_LINE=$STYLE_GIT_STATUS

# Git status characters
ZSH_PROMPT_GIT_STAGED='+'
ZSH_PROMPT_GIT_CONFLICTS='✘'
ZSH_PROMPT_GIT_CHANGED='!'
ZSH_PROMPT_GIT_UNTRACKED='?'
ZSH_PROMPT_GIT_BEHIND='↓'
ZSH_PROMPT_GIT_AHEAD='↑'
ZSH_PROMPT_GIT_CLEAN='' # consider "✔"

# ------------------------------------------------------------------------------



# Calculate length of string as if in prompt (excludes formatting characters)
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
  print $x
}

# Logic for line 1
do_separator=1 # false, is set true after prompting
if [ $IS_SSH = 0 ]; then
	do_separator=0 # assume it's not a fresh window
fi
add-zsh-hook preexec preexec_headline
preexec_headline() {
  if [[ $2 == 'clear' ]]; then
    do_separator=1
  fi
}

# Prompt line 1 and 2
add-zsh-hook precmd precmd_headline
precmd_headline() {
  # Prepend each style with reset and default styles
  local S_LINE=$reset$STYLE_LINE
  for part in USER HOST PATH GIT_BRANCH GIT_STATUS JOINTS; do
    eval local S_${part}="\$reset\$STYLE_DEFAULT\$STYLE_${part}"
    eval local S_${part}_LINE="\$reset\$STYLE_${part}_LINE"
  done

  # Aliases
  local A=$CHAR_LINE_ACCENT
  local L=$CHAR_LINE_FILL
  local J0=$JOINT_USER_BEGIN
  local J1=$JOINT_USER_TO_HOST
  local J2=$JOINT_HOST_TO_PATH
  local J3=$JOINT_PATH_TO_BRANCH
  local J3a=$JOINT_PATH_TO_PAD
  local J3b=$JOINT_PAD_TO_BRANCH
  local J4=$JOINT_BRANCH_TO_STATUS
  local J5=$JOINT_STATUS_END

  # <branch>
  local git_branch=$(git_prompt_branch)
  local git_branch_str=''
  if ! [[ -z $git_branch ]]; then
    git_branch_str="%{$S_GIT_BRANCH%}$PRE_GIT_BRANCH$git_branch$POST_GIT_BRANCH"
  fi
  local git_branch_str_len=$(prompt_len $git_branch_str)
  local git_branch_line="%{$S_GIT_BRANCH_LINE%}${(l:(( $git_branch_str_len * 2 ))::$A:)}"

  # <status>
  local git_status_str="%{$S_GIT_STATUS%}$PRE_GIT_STATUS$(git_prompt_status)$POST_GIT_STATUS"
  local git_status_str_len=$(prompt_len $git_status_str)
  local git_status_line="%{$S_GIT_STATUS_LINE%}${(pl:$git_status_str_len::$A:)}"

  # [<status>]
  if [ $git_status_str_len -gt 0 ]; then
    git_status_str="%{$S_JOINTS%}$J4$git_status_str%{$S_JOINTS%}$J5"
    git_status_str_len=$(( ${#J4} + $git_status_str_len + ${#J5} ))
    local jl4="%{$S_JOINTS_LINE%}${(pl:${#J4}::$L:)}"
    local jl5="%{$S_JOINTS_LINE%}${(pl:${#J5}::$L:)}"
    git_status_line="$jl4$git_status_line$jl5"
  fi

  # <branch> [<status>]
  local git_str_len=$(( $git_branch_str_len + $git_status_str_len ))
  local git_str="$git_branch_str$git_status_str"
  local git_line="$git_branch_line$git_status_line"

  # User & Host
  local user_name=$USER
  local host_name=$(hostname -s)
  if (( ${#user_name} + ${#host_name} + $git_str_len > $COLUMNS / 2 || $COLUMNS < 40 )); then
    user_name="${user_name:0:1}"
    host_name="${host_name:0:1}"
  fi

  # <user> @
  local user_str="%{$S_JOINTS%}$J0%{$S_USER%}$PRE_USER$user_name$POST_USER%{$S_JOINTS%}$J1"
  local user_str_len=$(prompt_len $user_str)
  local jl0="%{$S_JOINTS_LINE%}${(pl:${#J0}::$L:)}"
  local jl1="%{$S_JOINTS_LINE%}${(pl:${#J1}::$L:)}"
  local user_line="$jl0%{$S_USER_LINE%}${(pl:(( $user_str_len - ${#J0} - ${#J1} ))::$A:)}$jl1"

  # <host>:
  local host_str="%{$S_HOST%}$PRE_HOST$host_name$POST_HOST%{$S_JOINTS%}$J2"
  local host_str_len=$(prompt_len $host_str)
  local jl2="%{$S_JOINTS_LINE%}${(pl:${#J2}::$L:)}"
  local host_line="%{$S_HOST_LINE%}${(pl:(( $host_str_len - ${#J2} ))::$A:)}$jl2"

  # <path>
  local remainder_len=$(( $COLUMNS - $user_str_len - $host_str_len - ${#PRE_PATH} - ${#POST_PATH} - ($git_str_len ? ($git_str_len + ${#J3}) : 0) ))
  local path_str="%{$S_PATH%}$PRE_PATH%$remainder_len<...<%~%<<$POST_PATH"
  local path_str_len=$(prompt_len $path_str)
  local path_line="%{$S_PATH_LINE%}${(pl:$path_str_len::$A:)}"

  # Padding
  local spaces=$(( $COLUMNS - $user_str_len - $host_str_len - $path_str_len - $git_str_len ))
  local pad="%{$S_JOINTS%}$J3a${(l:(( $spaces - ${#J3a} - ${#J3b} )):: :)}$J3b"
  local pad_line="%{$S_LINE%}${(pl:$spaces::$L:)}"
  if (( $git_str_len > 0 )) && (( $spaces <= ${#J3} )); then
    pad="%{$S_JOINTS%}$J3"
    pad_line="%{$S_JOINTS_LINE%}${(pl:${#J3}::$L:)}"
  fi

  # _____
  if [[ $DO_LINE == 'on' || ($DO_LINE == 'auto' && $do_separator == 0 ) ]]; then
    print -rP "$user_line$host_line$path_line$pad_line$git_line$reset"
  fi
  do_separator=0

  # <user> @ <host>: <path>|---padding---|<branch> [<status>]
  print -rP "$user_str$host_str$path_str$pad$git_str$reset"

  # Debug
  # print "COLS: $COLUMNS, user: $user_str_len, host: $host_str_len, path: $path_str_len, pad: $spaces, git: $git_str_len, total: $(( $user_str_len + $host_str_len + $path_str_len + $spaces + $git_str_len ))"
}

# Prompt line 3
PROMPT="%(#.#.%(!.!.$)) " # double quote necessary
PROMPT_EOL_MARK=''
