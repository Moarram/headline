#!/bin/zsh
# To install, source this file from your .zshrc file
# Customization variables begin around line ??



# Constants for zsh
setopt PROMPT_SP # always start prompt on new line
setopt PROMPT_SUBST # substitutions
autoload -U add-zsh-hook

# Flags
! [ -z "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ]
IS_SSH=$?



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



# ------------------------------------------------------------------------------
# Customization
# I recommend setting these variables in your ~/.zshrc after sourcing this file
# The style aliases (defined above) can be used there too.

# Prompt options
HEADLINE_SEPARATOR_MODE='auto' # on|auto|off (whether to print the separator)

# Prompt character
HEADLINE_PROMPT="%(#.#.%(!.!.$)) " # consider "%#"

# Repeated characters (no styles here)
HEADLINE_SEPARATOR_CHAR_ACCENT='_' # line above info parts (user, host, path, etc)
HEADLINE_SEPARATOR_CHAR_FILL='_' # line above joints and spaces, consider " "

# Decoration strings (no styles here)
HEADLINE_JOINT_USER_BEGIN=''
HEADLINE_PRE_USER='' # consider " "
HEADLINE_POST_USER=''
HEADLINE_JOINT_USER_TO_HOST=' @ '
HEADLINE_PRE_HOST='' # consider " "
HEADLINE_POST_HOST=''
HEADLINE_JOINT_HOST_TO_PATH=': '
HEADLINE_PRE_PATH='' # consider " "
HEADLINE_POST_PATH=''
HEADLINE_JOINT_PATH_TO_BRANCH=' | ' # used when no padding between <path> and <branch>
HEADLINE_JOINT_PATH_TO_PAD='' # used if padding between <path> and <branch>
HEADLINE_JOINT_PAD_TO_BRANCH='' # used if padding between <path> and <branch>
HEADLINE_PRE_GIT_BRANCH='' # consider " "
HEADLINE_POST_GIT_BRANCH=''
HEADLINE_JOINT_BRANCH_TO_STATUS=' ['
HEADLINE_PRE_GIT_STATUS=''
HEADLINE_POST_GIT_STATUS=''
HEADLINE_JOINT_STATUS_END=']'

# Styles (ANSI SGR codes)
HEADLINE_STYLE_DEFAULT='' # style applied to entire info line
HEADLINE_STYLE_LINE=$light_black
HEADLINE_STYLE_JOINTS=$light_black
HEADLINE_STYLE_JOINTS_LINE=$light_black
if [ $IS_SSH = 0 ]; then
  HEADLINE_STYLE_USER=$bold$magenta
  HEADLINE_STYLE_USER_LINE=$HEADLINE_STYLE_USER
else
  HEADLINE_STYLE_USER=$bold$red
  HEADLINE_STYLE_USER_LINE=$HEADLINE_STYLE_USER
fi
HEADLINE_STYLE_HOST=$bold$yellow
HEADLINE_STYLE_HOST_LINE=$HEADLINE_STYLE_HOST
HEADLINE_STYLE_PATH=$bold$blue
HEADLINE_STYLE_PATH_LINE=$HEADLINE_STYLE_PATH
HEADLINE_STYLE_GIT_BRANCH=$bold$cyan
HEADLINE_STYLE_GIT_BRANCH_LINE=$HEADLINE_STYLE_GIT_BRANCH
HEADLINE_STYLE_GIT_STATUS=$bold$magenta
HEADLINE_STYLE_GIT_STATUS_LINE=$HEADLINE_STYLE_GIT_STATUS

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



# Calculate length of string, excluding formatting characters
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

# Local variables
headline_info='' # information line ouptut
headline_do_sep='false' # whether to show separator this time
if [ $IS_SSH = 0 ]; then
  headline_do_sep='true' # assume it's not a fresh window
fi

# Before executing command
add-zsh-hook preexec headline_preexec
headline_preexec() {
  if [[ $2 == 'clear' ]]; then
    headline_do_sep='false'
  fi
}

# Before prompting
add-zsh-hook precmd headline_precmd
headline_precmd() { # updates $headline_info and $headline_do_sep
  # Prepend each style with reset and default styles
  local S_LINE=$reset$HEADLINE_STYLE_LINE
  for part in USER HOST PATH GIT_BRANCH GIT_STATUS JOINTS; do
    eval local S_${part}="\$reset\$HEADLINE_STYLE_DEFAULT\$HEADLINE_STYLE_${part}"
    eval local S_${part}_LINE="\$reset\$HEADLINE_STYLE_${part}_LINE"
  done

  # Aliases
  local A=$HEADLINE_SEPARATOR_CHAR_ACCENT
  local L=$HEADLINE_SEPARATOR_CHAR_FILL
  local J0=$HEADLINE_JOINT_USER_BEGIN
  local J1=$HEADLINE_JOINT_USER_TO_HOST
  local J2=$HEADLINE_JOINT_HOST_TO_PATH
  local J3=$HEADLINE_JOINT_PATH_TO_BRANCH
  local J3a=$HEADLINE_JOINT_PATH_TO_PAD
  local J3b=$HEADLINE_JOINT_PAD_TO_BRANCH
  local J4=$HEADLINE_JOINT_BRANCH_TO_STATUS
  local J5=$HEADLINE_JOINT_STATUS_END

  # <branch>
  local git_branch=$(headline_git_branch)
  local git_branch_str=''
  if ! [[ -z $git_branch ]]; then
    git_branch_str="%{$S_GIT_BRANCH%}$HEADLINE_PRE_GIT_BRANCH$git_branch$HEADLINE_POST_GIT_BRANCH"
  fi
  local git_branch_str_len=$(headline_prompt_len $git_branch_str)
  local git_branch_line="%{$S_GIT_BRANCH_LINE%}${(pl:$git_branch_str_len::$A:)}"

  # <status>
  local git_status=$(headline_git_status)
  local git_status_str="%{$S_GIT_STATUS%}$HEADLINE_PRE_GIT_STATUS$git_status$HEADLINE_POST_GIT_STATUS"
  local git_status_str_len=$(headline_prompt_len $git_status_str)
  local git_status_line="%{$S_GIT_STATUS_LINE%}${(pl:$git_status_str_len::$A:)}"

  # [<status>]
  if [ ${#git_status} -gt 0 ]; then
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
  local user_str="%{$S_JOINTS%}$J0%{$S_USER%}$HEADLINE_PRE_USER$user_name$HEADLINE_POST_USER%{$S_JOINTS%}$J1"
  local user_str_len=$(headline_prompt_len $user_str)
  local jl0="%{$S_JOINTS_LINE%}${(pl:${#J0}::$L:)}"
  local jl1="%{$S_JOINTS_LINE%}${(pl:${#J1}::$L:)}"
  local user_line="$jl0%{$S_USER_LINE%}${(pl:(( $user_str_len - ${#J0} - ${#J1} ))::$A:)}$jl1"

  # <host>:
  local host_str="%{$S_HOST%}$HEADLINE_PRE_HOST$host_name$HEADLINE_POST_HOST%{$S_JOINTS%}$J2"
  local host_str_len=$(headline_prompt_len $host_str)
  local jl2="%{$S_JOINTS_LINE%}${(pl:${#J2}::$L:)}"
  local host_line="%{$S_HOST_LINE%}${(pl:(( $host_str_len - ${#J2} ))::$A:)}$jl2"

  # <path>
  local remainder_len=$(( $COLUMNS - $user_str_len - $host_str_len - ${#HEADLINE_PRE_PATH} - ${#HEADLINE_POST_PATH} - ($git_str_len ? ($git_str_len + ${#J3}) : 0) ))
  local path_str="%{$S_PATH%}$HEADLINE_PRE_PATH%$remainder_len<...<%~%<<$HEADLINE_POST_PATH"
  local path_str_len=$(headline_prompt_len $path_str)
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
  if [[ $HEADLINE_SEPARATOR_MODE == 'on' || ($HEADLINE_SEPARATOR_MODE == 'auto' && $headline_do_sep == 'true' ) ]]; then
    print -rP "$user_line$host_line$path_line$pad_line$git_line$reset"
  fi
  headline_do_sep='true'

  # <user> @ <host>: <path>|---padding---|<branch> [<status>]
  headline_info="$user_str$host_str$path_str$pad$git_str$reset" # printed as part of PROMPT so it shows with Ctrl+L

  # Debug
  # print "COLS: $COLUMNS, user: $user_str_len, host: $host_str_len, path: $path_str_len, pad: $spaces, git: $git_str_len, total: $(( $user_str_len + $host_str_len + $path_str_len + $spaces + $git_str_len ))"
}

# Prompt
headline_output() {
  print -rP $headline_info
  print -rP $HEADLINE_PROMPT
}
PROMPT='$(headline_output)'
PROMPT_EOL_MARK=''
