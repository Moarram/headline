#!/bin/zsh

# Headline ZSH Prompt
# Copyright (c) 2021 Moarram under the MIT License

# To install, source this file from your .zshrc file
# Customization variables begin around line 80



# Character aliases
newline=$'\n'

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

# Prompt options
HEADLINE_LINE_MODE='auto' # on|auto|off (whether to print the line above the prompt)
HEADLINE_INFO_MODE='precmd' # precmd|prompt (whether info line is in $PROMPT or printed by precmd)
  # use "precmd" for window resize to work properly (Ctrl+L doesn't show info line)
  # use "prompt" for Ctrl+L to clear properly (window resize eats previous output)

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
HEADLINE_STATUS_END=']'

# Styles (ANSI SGR codes)
HEADLINE_STYLE_DEFAULT='' # style applied to entire info line
HEADLINE_STYLE_LINE=$light_black
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
HEADLINE_GIT_HASH=':' # prefix

# Git status styles and characters
# To set individual status styles use "%{<style>%}<char>"
HEADLINE_GIT_STAGED='+' # added or renamed
HEADLINE_GIT_CHANGED='!' # modified or deleted
HEADLINE_GIT_UNTRACKED='?'
HEADLINE_GIT_BEHIND='↓'
HEADLINE_GIT_AHEAD='↑'
HEADLINE_GIT_DIVERGED='↕'
HEADLINE_GIT_STASHED='*'
HEADLINE_GIT_CONFLICTS='✘'
HEADLINE_GIT_CLEAN='' # consider "✓" or "✔"

# ------------------------------------------------------------------------------



# Constants for zsh
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
  print $x
}



# Git command wrapper
# adapted from Oh-My-Zsh under MIT License
headline_git() {
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Git branch (or hash)
# adapted from Oh-My-Zsh under MIT License
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
# adapted from Oh-My-Zsh under MIT License
headline_git_status() {
  # Maps a git status prefix to an internal constant
  # This cannot use the prompt constants, as they may be empty
  local -A prefix_constant_map
  prefix_constant_map=(
    '\?\? '     'UNTRACKED'
    'A  '       'STAGED' # added
    'M  '       'STAGED' # added
    'MM '       'CHANGED' # modified
    ' M '       'CHANGED' # modified
    'AM '       'CHANGED' # modified
    ' T '       'CHANGED' # modified
    'R  '       'STAGED' # renamed
    ' D '       'CHANGED' # deleted
    'D  '       'STAGED' # deleted
    'UU '       'CONFLICT' # unmerged
    'ahead'     'AHEAD'
    'behind'    'BEHIND'
    'diverged'  'DIVERGED'
    'stashed'   'STASHED'
  )

  # Maps the internal constant to the prompt theme
  local -A constant_prompt_map
  constant_prompt_map=(
    'UNTRACKED' "$HEADLINE_GIT_UNTRACKED"
    'STAGED'    "$HEADLINE_GIT_STAGED"
    'CHANGED'   "$HEADLINE_GIT_CHANGED"
    'CONFLICT'  "$HEADLINE_GIT_CONFLICT"
    'AHEAD'     "$HEADLINE_GIT_AHEAD"
    'BEHIND'    "$HEADLINE_GIT_BEHIND"
    'DIVERGED'  "$HEADLINE_GIT_DIVERGED"
    'STASHED'   "$HEADLINE_GIT_STASHED"
  )

  # The order that the prompt displays should be added to the prompt
  local status_constants
  status_constants=(STAGED CHANGED UNTRACKED BEHIND AHEAD DIVERGED STASHED CONFLICT)

  # Retrieve status (note the --porcelain flag)
  local status_text
  status_text="$(headline_git status --porcelain -b 2> /dev/null)"
  if [[ $? == 128 ]]; then
    return 1 # catastrophic failure, abort
  fi

  # A lookup table of each git status encountered
  local -A statuses_seen

  # Check for stashes
  if $(headline_git rev-parse --verify refs/stash &> /dev/null); then
    statuses_seen[STASHED]=$(headline_git rev-list --walk-reflogs --count refs/stash)
  fi

  local status_lines
  status_lines=("${(@f)${status_text}}")

  # If the tracking line exists, get and parse it
  if [[ "$status_lines[1]" =~ "^## [^ ]+ \[(.*)\]" ]]; then
    local branch_statuses
    branch_statuses=("${(@s/,/)match}")
    for branch_status in $branch_statuses; do
      if [[ ! $branch_status =~ "(behind|diverged|ahead) ([0-9]+)?" ]]; then
        continue
      fi
      local last_parsed_status=$prefix_constant_map[$match[1]]
      statuses_seen[$last_parsed_status]=$match[2]
    done
  fi

  # For each status prefix, do a regex comparison
  for status_prefix in ${(k)prefix_constant_map}; do
    local status_constant="${prefix_constant_map[$status_prefix]}"
    local status_regex=$'(^|\n)'"$status_prefix"
    if [[ "$status_text" =~ $status_regex ]]; then
      statuses_seen[$status_constant]=1 # TODO number of occurences
    fi
  done

  # Display the seen statuses in the order specified
  local status_prompt
  for status_constant in $status_constants; do
    if (( ${+statuses_seen[$status_constant]} )); then
      local symbol=$constant_prompt_map[$status_constant]
      status_prompt="$status_prompt$symbol"
      # local value=$statuses_seen[$status_constant]
      # status_prompt="$status_prompt$value$symbol"
    fi
  done

  # Return
  if (( ${#status_prompt} )); then
    echo $status_prompt
  else
    echo $HEADLINE_GIT_CLEAN
  fi
}

# # Git branch only, using vcs_info
# autoload -Uz vcs_info
# zstyle ':vcs_info:git:*' formats '%b'
# headline_git_branch() {
#   vcs_info
#   echo $vcs_info_msg_0_
# }
# headline_git_status() { echo '' }



# Before executing command
add-zsh-hook preexec headline_preexec
headline_preexec() {
  if [[ $2 == 'clear' ]]; then
    _HEADLINE_DO_SEP='false'
  fi
}

# Before prompting
add-zsh-hook precmd headline_precmd
headline_precmd() {
  # Information
  local user_str=$USER
  local host_str=$(hostname -s)
  local path_str=$(print -rP '%~')
  local branch_str=$(headline_git_branch)
  local status_str=$(headline_git_status)

  # Shared variables
  _HEADLINE_INFO=''
  _HEADLINE_LINE=''
  _HEADLINE_LEN=0
  _HEADLINE_LEN_SUM=0
  _HEADLINE_INFO_LEFT=''
  _HEADLINE_LINE_LEFT=''
  _HEADLINE_INFO_RIGHT=''
  _HEADLINE_LINE_RIGHT=''

  # Prompt construction
  local git_str_len remain
  if (( ${#status_str} > 0 )); then
    _headline_part JOINT "$HEADLINE_STATUS_END" right
    _headline_part STATUS "$HEADLINE_STATUS_PREFIX$status_str" right
    _headline_part JOINT "$HEADLINE_BRANCH_TO_STATUS" right
  fi
  if (( ${#branch_str} > 0 )); then
    _headline_part BRANCH "$HEADLINE_BRANCH_PREFIX$branch_str" right
  fi
  git_str_len=$_HEADLINE_LEN_SUM
  if (( $git_str_len + ${#user_str} + ${#host_str} > $COLUMNS / 2 || $COLUMNS < 40 )); then
    user_str="${user_str:0:1}"
    host_str="${host_str:0:1}"
  fi
  _headline_part JOINT "$HEADLINE_USER_BEGIN" left
  _headline_part USER "$HEADLINE_USER_PREFIX$user_str" left
  _headline_part JOINT "$HEADLINE_USER_TO_HOST" left
  _headline_part HOST "$HEADLINE_HOST_PREFIX$host_str" left
  _headline_part JOINT "$HEADLINE_HOST_TO_PATH" left
  remain=$(( $COLUMNS - $_HEADLINE_LEN_SUM - ( $git_str_len ? ${#HEADLINE_PATH_TO_BRANCH} : 0 ) ))
  _headline_part PATH "$HEADLINE_PATH_PREFIX%$remain<...<$path_str%<<" left
  remain=$(( $COLUMNS - $_HEADLINE_LEN_SUM - ${#HEADLINE_PATH_TO_PAD} - ${#HEADLINE_PAD_TO_BRANCH} ))
  if (( $git_str_len && $COLUMNS - $_HEADLINE_LEN_SUM <= ${#HEADLINE_PATH_TO_BRANCH} )); then
    _headline_part JOINT "$HEADLINE_PATH_TO_BRANCH" left
  else
    _headline_part JOINT "$HEADLINE_PATH_TO_PAD" left
    _headline_part JOINT "${(pl:$remain::$HEADLINE_PAD_CHAR:)}" left
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
  local style
  eval style="\$reset\$HEADLINE_STYLE_DEFAULT\$HEADLINE_STYLE_${1}"
  _HEADLINE_INFO="%{$style%}$2"
  _HEADLINE_LEN=$(headline_prompt_len $_HEADLINE_INFO)
  _HEADLINE_LEN_SUM=$(( $_HEADLINE_LEN_SUM + $_HEADLINE_LEN ))
  eval style="\$reset\$HEADLINE_STYLE_${1}_LINE"
  _HEADLINE_LINE="%{$style%}${(pl:$_HEADLINE_LEN::$HEADLINE_LINE_CHAR:)}"
  if [[ $3 == 'left' ]]; then
    _HEADLINE_INFO_LEFT="$_HEADLINE_INFO_LEFT$_HEADLINE_INFO"
    _HEADLINE_LINE_LEFT="$_HEADLINE_LINE_LEFT$_HEADLINE_LINE"
  else
    _HEADLINE_INFO_RIGHT="$_HEADLINE_INFO$_HEADLINE_INFO_RIGHT"
    _HEADLINE_LINE_RIGHT="$_HEADLINE_LINE$_HEADLINE_LINE_RIGHT"
  fi
}

# Prompt
headline_output() {
  print -rP $_HEADLINE_INFO_OUTPUT
  print -rP $HEADLINE_PROMPT
}
if [[ $HEADLINE_INFO_MODE == 'precmd' ]]; then
  PROMPT=$HEADLINE_PROMPT
else
  PROMPT='$(headline_output)'
fi
PROMPT_EOL_MARK=''
