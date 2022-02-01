#!/bin/zsh

# Headline ZSH Prompt
# Copyright (c) 2021 Moarram under the MIT License

# To install, source this file from your .zshrc file
# Customization variables begin around line 70



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

# Flags
! [ -z "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ]
IS_SSH=$?



# ------------------------------------------------------------------------------
# Customization
# I recommend setting these variables in your ~/.zshrc after sourcing this file
# The style aliases for ANSI SGR codes (defined above) can be used there too

# Options
HEADLINE_LINE_MODE='auto' # on|auto|off (whether to print the line above the prompt)
HEADLINE_INFO_MODE='precmd' # precmd|prompt (whether info line is in $PROMPT or printed by precmd)
  # use "precmd" for window resize to work properly (but Ctrl+L doesn't show info line)
  # use "prompt" for Ctrl+L to clear properly (but window resize eats previous output)

# Segments
HEADLINE_DO_USER='true'
HEADLINE_DO_HOST='true'
HEADLINE_DO_PATH='true'
HEADLINE_DO_GIT_BRANCH='true'
HEADLINE_DO_GIT_STATUS='true'

# Prompt character
HEADLINE_PROMPT="%(#.#.%(!.!.$)) " # consider "%#"

# Repeated characters (no styles here)
HEADLINE_LINE_CHAR='_' # line above information
HEADLINE_PAD_CHAR=' ' # space between <path> and <branch>

# Prefixes (optional)
HEADLINE_USER_PREFIX='' # consider " "
HEADLINE_HOST_PREFIX='' # consider " "
HEADLINE_PATH_PREFIX='' # consider " "
HEADLINE_BRANCH_PREFIX='' # consider " "

# Joints
HEADLINE_USER_BEGIN=''
HEADLINE_USER_TO_HOST=' @ '
HEADLINE_HOST_TO_PATH=': '
HEADLINE_PATH_TO_BRANCH=' | ' # only used when no padding between <path> and <branch>
HEADLINE_PATH_TO_PAD='' # used if padding between <path> and <branch>
HEADLINE_PAD_TO_BRANCH='' # used if padding between <path> and <branch>
HEADLINE_BRANCH_TO_STATUS=' ['
HEADLINE_STATUS_TO_STATUS='' # between each status section, consider "]"
HEADLINE_STATUS_END=']'

# Info styles (ANSI SGR codes)
HEADLINE_STYLE_DEFAULT='' # style applied to entire info line
HEADLINE_STYLE_JOINT=$light_black
if [ $IS_SSH = 0 ]; then
  HEADLINE_STYLE_USER=$bold$magenta
else
  HEADLINE_STYLE_USER=$bold$red
fi
HEADLINE_STYLE_HOST=$bold$yellow
HEADLINE_STYLE_PATH=$bold$blue
HEADLINE_STYLE_BRANCH=$bold$cyan
HEADLINE_STYLE_STATUS=$bold$magenta

# Line styles
HEADLINE_STYLE_JOINT_LINE=$HEADLINE_STYLE_JOINT
HEADLINE_STYLE_USER_LINE=$HEADLINE_STYLE_USER
HEADLINE_STYLE_HOST_LINE=$HEADLINE_STYLE_HOST
HEADLINE_STYLE_PATH_LINE=$HEADLINE_STYLE_PATH
HEADLINE_STYLE_BRANCH_LINE=$HEADLINE_STYLE_BRANCH
HEADLINE_STYLE_STATUS_LINE=$HEADLINE_STYLE_STATUS

# Git branch characters
HEADLINE_GIT_HASH=':' # hash prefix to distinguish from branch

# Git status options
HEADLINE_DO_GIT_STATUS_COUNTS='false' # set "true" to show count of each status
HEADLINE_DO_GIT_STATUS_OMIT_ONE='false' # set "true" to omit the status number when it is 1

# Git status styles and characters
# To set individual status styles use "%{$reset<style>%}<char>"
HEADLINE_GIT_STAGED='+'
HEADLINE_GIT_CHANGED='!'
HEADLINE_GIT_UNTRACKED='?'
HEADLINE_GIT_BEHIND='↓'
HEADLINE_GIT_AHEAD='↑'
HEADLINE_GIT_DIVERGED='↕'
HEADLINE_GIT_STASHED='*'
HEADLINE_GIT_CONFLICTS='✘' # consider "%{$red%}✘"
HEADLINE_GIT_CLEAN='' # consider "✓" or "✔"

# ------------------------------------------------------------------------------



# Options for zsh
setopt PROMPT_SP # always start prompt on new line
setopt PROMPT_SUBST # substitutions
autoload -U add-zsh-hook

# Local variables
_HEADLINE_LINE_OUTPUT='' # separator line
_HEADLINE_INFO_OUTPUT='' # text line
_HEADLINE_DO_SEP='false' # whether to show divider this time
if [ $IS_SSH = 0 ]; then
  _HEADLINE_DO_SEP='true' # assume it's not a fresh window
fi

# Calculate length of string, excluding formatting characters
# REF: https://old.reddit.com/r/zsh/comments/cgbm24/multiline_prompt_the_missing_ingredient/
headline_prompt_len() {
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
  echo $x
}

# Repeat character a number of times
# (replacing the "${(pl:$num::$char:)}" expansion)
headline_repeat_char() { # (char, num)
  local str=''
  for (( i = 0; i < $2; i++ )); do
    str+=$1
  done
  echo $str
}



# Git command wrapper
headline_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Git branch (or hash)
headline_git_branch() {
  local ref
  ref=$(headline_git symbolic-ref --quiet HEAD 2> /dev/null)
  local ret=$?
  if [[ $ret == 0 ]]; then
    echo ${ref#refs/heads/} # remove "refs/heads/" to get branch
  else # not on a branch
    [[ $ret == 128 ]] && return  # not a git repo
    ref=$(headline_git rev-parse --short HEAD 2> /dev/null) || return
    echo "$HEADLINE_GIT_HASH$ref" # hash prefixed to distingush from branch
  fi
}

# Git status
headline_git_status() {
  # Data structures
  local order; order=('STAGED' 'CHANGED' 'UNTRACKED' 'BEHIND' 'AHEAD' 'DIVERGED' 'STASHED' 'CONFLICTS')
  local -A totals
  for key in $order; do
    totals+=($key 0)
  done

  # Retrieve status
  # REF: https://git-scm.com/docs/git-status
  local raw lines
  raw="$(headline_git status --porcelain -b 2> /dev/null)"
  if [[ $? == 128 ]]; then
    return 1 # catastrophic failure, abort
  fi
  lines=(${(@f)raw})

  # Process tracking line
  if [[ ${lines[1]} =~ '^## [^ ]+ \[(.*)\]' ]]; then
    local items=("${(@s/,/)match}")
    for item in $items; do
      if [[ $item =~ '(behind|ahead|diverged) ([0-9]+)?' ]]; then
        case $match[1] in
          'behind') totals[BEHIND]=$match[2];;
          'ahead') totals[AHEAD]=$match[2];;
          'diverged') totals[DIVERGED]=$match[2];;
        esac
      fi
    done
  fi

  # Process status lines
  for line in $lines; do
    if [[ $line =~ '^##|^!!' ]]; then
      continue
    elif [[ $line =~ '^U[ADU]|^[AD]U|^AA|^DD' ]]; then
      totals[CONFLICTS]=$(( ${totals[CONFLICTS]} + 1 ))
    elif [[ $line =~ '^\?\?' ]]; then
      totals[UNTRACKED]=$(( ${totals[UNTRACKED]} + 1 ))
    elif [[ $line =~ '^[MTADRC] ' ]]; then
      totals[STAGED]=$(( ${totals[STAGED]} + 1 ))
    elif [[ $line =~ '^[MTARC][MTD]' ]]; then
      totals[STAGED]=$(( ${totals[STAGED]} + 1 ))
      totals[CHANGED]=$(( ${totals[CHANGED]} + 1 ))
    elif [[ $line =~ '^ [MTADRC]' ]]; then
      totals[CHANGED]=$(( ${totals[CHANGED]} + 1 ))
    fi
  done

  # Check for stashes
  if $(headline_git rev-parse --verify refs/stash &> /dev/null); then
    totals[STASHED]=$(headline_git rev-list --walk-reflogs --count refs/stash 2> /dev/null)
  fi

  # Build string
  local prefix status_str
  status_str=''
  for key in $order; do
    if (( ${totals[$key]} > 0 )); then
      if (( ${#HEADLINE_STATUS_TO_STATUS} && ${#status_str} )); then # not first iteration
        local style_joint="$reset$HEADLINE_STYLE_DEFAULT$HEADLINE_STYLE_JOINT"
        local style_status="$resetHEADLINE_STYLE_DEFAULT$HEADLINE_STYLE_STATUS"
        status_str="$status_str%{$style_joint%}$HEADLINE_STATUS_TO_STATUS%{$style_status%}"
      fi
      eval prefix="\$HEADLINE_GIT_${key}"
      if [[ $HEADLINE_DO_GIT_STATUS_COUNTS == 'true' ]]; then
        if [[ $HEADLINE_DO_GIT_STATUS_OMIT_ONE == 'true' && (( ${totals[$key]} == 1 )) ]]; then
          status_str="$status_str$prefix"
        else
          status_str="$status_str${totals[$key]}$prefix"
        fi
      else
        status_str="$status_str$prefix"
      fi
    fi
  done

  # Return
  if (( ${#status_str} )); then
    echo $status_str
  else
    echo $HEADLINE_GIT_CLEAN
  fi
}



# Before executing command
add-zsh-hook preexec headline_preexec
headline_preexec() {
  # TODO better way of knowing the prompt is at the top of the terminal
  if [[ $2 == 'clear' ]]; then
    _HEADLINE_DO_SEP='false'
  fi
}

# Before prompting
add-zsh-hook precmd headline_precmd
headline_precmd() {
  # Information
  local user_str host_str path_str branch_str status_str
  [[ $HEADLINE_DO_USER == 'true' ]] && user_str=$USER
  [[ $HEADLINE_DO_HOST == 'true' ]] && host_str=$(hostname -s)
  [[ $HEADLINE_DO_PATH == 'true' ]] && path_str=$(print -rP '%~')
  [[ $HEADLINE_DO_GIT_BRANCH == 'true' ]] && branch_str=$(headline_git_branch)
  [[ $HEADLINE_DO_GIT_STATUS == 'true' ]] && status_str=$(headline_git_status)

  # Trimming
  if (( $COLUMNS < 35 && ${#path_str} )); then
    user_str=''; host_str=''
  elif (( $COLUMNS < 55 )); then
    user_str="${user_str:0:1}"
    host_str="${host_str:0:1}"
  fi

  # Shared variables
  _HEADLINE_LEN=0
  _HEADLINE_LEN_SUM=0
  _HEADLINE_INFO_LEFT=''
  _HEADLINE_LINE_LEFT=''
  _HEADLINE_INFO_RIGHT=''
  _HEADLINE_LINE_RIGHT=''

  # Prompt construction
  local git_len len
  if (( ${#status_str} )); then
    _headline_part JOINT "$HEADLINE_STATUS_END" right
    _headline_part STATUS "$HEADLINE_STATUS_PREFIX$status_str" right
    _headline_part JOINT "$HEADLINE_BRANCH_TO_STATUS" right
  fi
  if (( ${#branch_str} )); then
    _headline_part BRANCH "$HEADLINE_BRANCH_PREFIX$branch_str" right
  fi
  git_len=$_HEADLINE_LEN_SUM
  if (( ${#user_str} )); then
    _headline_part JOINT "$HEADLINE_USER_BEGIN" left
    _headline_part USER "$HEADLINE_USER_PREFIX$user_str" left
  fi
  if (( ${#host_str} )); then
    if (( ${#_HEADLINE_INFO_LEFT} )); then
      _headline_part JOINT "$HEADLINE_USER_TO_HOST" left
    fi
    _headline_part HOST "$HEADLINE_HOST_PREFIX$host_str" left
  fi
  if (( ${#path_str} )); then
    if (( ${#_HEADLINE_INFO_LEFT} )); then
      _headline_part JOINT "$HEADLINE_HOST_TO_PATH" left
    fi
    len=$(( $COLUMNS - $_HEADLINE_LEN_SUM - ( $git_len ? ${#HEADLINE_PATH_TO_BRANCH} + ${#HEADLINE_PATH_PREFIX} : 0 ) ))
    _headline_part PATH "$HEADLINE_PATH_PREFIX%$len<...<$path_str%<<" left
  fi
  len=$(( $COLUMNS - $_HEADLINE_LEN_SUM - ${#HEADLINE_PATH_TO_PAD} - ${#HEADLINE_PAD_TO_BRANCH} ))
  if (( $git_len && $COLUMNS - $_HEADLINE_LEN_SUM <= ${#HEADLINE_PATH_TO_BRANCH} )); then
    _headline_part JOINT "$HEADLINE_PATH_TO_BRANCH" left
  else
    _headline_part JOINT "$HEADLINE_PATH_TO_PAD" left
    _headline_part JOINT "$(headline_repeat_char $HEADLINE_PAD_CHAR $len)" left
    _headline_part JOINT "$HEADLINE_PAD_TO_BRANCH" left
  fi

  # Separator line
  _HEADLINE_LINE_OUTPUT="$_HEADLINE_LINE_LEFT$_HEADLINE_LINE_RIGHT$reset"
  if [[ $HEADLINE_LINE_MODE == 'on' || ($HEADLINE_LINE_MODE == 'auto' && $_HEADLINE_DO_SEP == 'true' ) ]]; then
    print -rP $_HEADLINE_LINE_OUTPUT
  fi
  _HEADLINE_DO_SEP='true'

  # Information line
  _HEADLINE_INFO_OUTPUT="$_HEADLINE_INFO_LEFT$_HEADLINE_INFO_RIGHT$reset"
  if [[ $HEADLINE_INFO_MODE == 'precmd' ]]; then
    print -rP $_HEADLINE_INFO_OUTPUT
  fi
}

# Create a part of the prompt
_headline_part() { # (name, content, side)
  local style info line
  eval style="\$reset\$HEADLINE_STYLE_DEFAULT\$HEADLINE_STYLE_${1}"
  info="%{$style%}$2"
  _HEADLINE_LEN=$(headline_prompt_len $info 9999)
  _HEADLINE_LEN_SUM=$(( $_HEADLINE_LEN_SUM + $_HEADLINE_LEN ))
  eval style="\$reset\$HEADLINE_STYLE_${1}_LINE"
  line="%{$style%}$(headline_repeat_char $HEADLINE_LINE_CHAR $_HEADLINE_LEN)"
  if [[ $3 == 'right' ]]; then
    _HEADLINE_INFO_RIGHT="$info$_HEADLINE_INFO_RIGHT"
    _HEADLINE_LINE_RIGHT="$line$_HEADLINE_LINE_RIGHT"
  else
    _HEADLINE_INFO_LEFT="$_HEADLINE_INFO_LEFT$info"
    _HEADLINE_LINE_LEFT="$_HEADLINE_LINE_LEFT$line"
  fi
}

# Prompt
headline_output() {
  print -rP $_HEADLINE_INFO_OUTPUT
  print -rP $HEADLINE_PROMPT
}
if [[ $HEADLINE_INFO_MODE == 'precmd' ]]; then
  PROMPT=$HEADLINE_PROMPT # line and info printed by precmd
else
  PROMPT='$(headline_output)' # only line printed by precmd
fi
PROMPT_EOL_MARK=''
