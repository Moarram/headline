#!/bin/zsh

# Headline ZSH Prompt
# Copyright (c) 2024 Moarram under the MIT License

# To install, source this file from your ~/.zshrc
# Customization variables begin around line 80


# Formatting aliases
# (add more if you need)
reset=$'\e[0m'
bold=$'\e[1m'
faint=$'\e[2m';     no_faint_bold=$'\e[22m'
italic=$'\e[3m';    no_italic=$'\e[23m'
underline=$'\e[4m'; no_underline=$'\e[24m'
invert=$'\e[7m';    no_invert=$'\e[27m'
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
default_fg=$'\e[39m'

# Background color aliases
black_bg=$'\e[40m'
red_bg=$'\e[41m'
green_bg=$'\e[42m'
yellow_bg=$'\e[43m'
blue_bg=$'\e[44m'
magenta_bg=$'\e[45m'
cyan_bg=$'\e[46m'
white_bg=$'\e[47m'
light_black_bg=$'\e[100m'
light_red_bg=$'\e[101m'
light_green_bg=$'\e[102m'
light_yellow_bg=$'\e[103m'
light_blue_bg=$'\e[104m'
light_magenta_bg=$'\e[105m'
light_cyan_bg=$'\e[106m'
light_white_bg=$'\e[107m'
default_bg=$'\e[49m'

# Custom colors
# Ref: https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters
# orange_yellow=$'\e[38;5;214m' # example 8-bit color (n=214)
# orange_brown=$'\e[38;2;191;116;46m' # example rgb color (r=119, g=116, b=46)
# ...

# Terminal control aliases
cursor_up=$'\e[1F'
cursor_show=$'\e[?25h'
cursor_hide=$'\e[?25l'
cursor_to_top_left_corner=$'\e[H'
clear_entire_screen=$'\e[2J'
# ...

# Flags
[ ! -z "$SSH_TTY$SSH_CONNECTION$SSH_CLIENT" ] && IS_SSH='true'



# ------------------------------------------------------------------------------
# Customization
# Use the following variables to customize the theme.
# If you're setting them in ~/.zshrc, source the theme, THEN set the variables.
# To insert styles (ANSI SGR codes defined above) use syntax: "%{$style%}"


# Print separator and information line with precmd hook or in PROMPT
HL_PRINT_MODE='precmd' # precmd|prompt

# Print the separator line always, when not following clear screen, or don't print
HL_SEP_MODE='auto' # on|auto|off

# Print the information line always, when it has changed, or don't print
HL_INFO_MODE='on' # on|auto|off

# Press <enter> with no commands to overwrite previous prompt
HL_OVERWRITE='off' # on|off


# Style applied to separator line, after other styles
HL_SEP_STYLE="%{$default_bg%}"

# Segments of the separator line
declare -A HL_SEP=(
  _PRE  ''
  _LINE '_' # repeated char to create separator line, consider '▁'
  _POST ''
)


# Style applied to all segments, before other styles
HL_BASE_STYLE=""

# Style of segment layout template
HL_LAYOUT_STYLE="%{$faint%}"

# Order of segments
declare -a HL_LAYOUT_ORDER=(
  _PRE USER HOST VENV PATH _SPACER BRANCH STATUS _POST # ...
)

# Template for each segment's layout
declare -A HL_LAYOUT_TEMPLATE=(
  _PRE    "${IS_SSH+=> }" # shows "=> " if this is an ssh session
  USER    '...'
  HOST    ' @ ...'
  VENV    ' (...)'
  PATH    ': ...'
  _SPACER ' | ' # special, only shows when compact, otherwise fill with space
  BRANCH  '...'
  STATUS  ' [...]'
  _POST   ''
  # ...
)

# Template for first segment's layout (when prior segments removed)
declare -A HL_LAYOUT_FIRST=(
  VENV    '(...)'
  PATH    '...'
  _SPACER ''
  # ...
)

# The character used by _SPACER segment to fill space
HL_SPACE_CHAR=' '


# Template for each segment's content
declare -A HL_CONTENT_TEMPLATE=(
  USER   "%{$bold$red%}..." # consider ' ' or ' '
  HOST   "%{$bold$yellow%}..." # consider '󰇅 ' or ' '
  VENV   "%{$bold$green%}..." # consider ' ' or ' '
  PATH   "%{$bold$blue%}..." # consider ' ' or ' '
  BRANCH "%{$bold$cyan%}..." # consider ' ' or ' '
  STATUS "%{$bold$magenta%}..."
  # ...
)

# Commands to produce each segment's content
declare -A HL_CONTENT_SOURCE=(
  USER   'echo $USER'
  HOST   'hostname -s'
  VENV   'basename "$VIRTUAL_ENV"'
  PATH   'print -rP "%~"'
  BRANCH 'headline-git-branch'
  STATUS 'headline-git-status'
  # ...
)


# Show count of each status always, only when greater than one, or don't show
HL_GIT_COUNT_MODE='off' # on|auto|off

# Symbol to join each status
HL_GIT_SEP_SYMBOL=''

# Order of statuses
declare -a HL_GIT_STATUS_ORDER=(
  STAGED CHANGED UNTRACKED BEHIND AHEAD DIVERGED STASHED CONFLICTS CLEAN
)

# Symbol for each status
declare -A HL_GIT_STATUS_SYMBOLS=(
  STAGED    '+'
  CHANGED   '!'
  UNTRACKED '?'
  BEHIND    '↓'
  AHEAD     '↑'
  DIVERGED  '↕'
  STASHED   '*'
  CONFLICTS '✘' # consider "%{$red%}✘"
  CLEAN     '' # consider '✓' or "%{$green%}✔"
)


# Minimum screen width to show segment
declare -A HL_COLS_REMOVAL=(
  USER   50
  HOST   70
  VENV   30
  # ...
)

# Order to truncate & remove segments
declare -a HL_TRUNC_ORDER=(
  HOST USER VENV PATH BRANCH # ...
)

# Symbol to insert when truncating a segment
HL_TRUNC_SYMBOL='...' # consider '…'

# Minimum segment length for initial truncation
HL_TRUNC_INITIAL=16

# Minimum segment length before removal
HL_TRUNC_REMOVAL=2


# Prompt
HL_PROMPT='%(#.#.%(!.!.$)) ' # consider '%#'

# Right prompt
HL_RPROMPT=''


# Show the clock, or don't show
HL_CLOCK_MODE='off' # on|off

# Template for the clock
HL_CLOCK_TEMPLATE="%{$faint%}..."

# Command which outputs clock content
HL_CLOCK_SOURCE='date "+%l:%M:%S %p"' # consider 'date +%+' for full date


# Show non-zero exit code, include a guessed meaning too, or don't show
HL_ERR_MODE='off' # on|detail|off

# Template for the exit code
HL_ERR_TEMPLATE="%{$faint$italic%}→ ..."

# Template for the optional detail
HL_ERR_DETAIL_TEMPLATE=' (...)'


# The string to replace in templates
HL_TEMPLATE_TOKEN='...'

# ------------------------------------------------------------------------------



# Output variables
HL_OUTPUT_SEP='' # printed separator line
HL_OUTPUT_INFO='' # printed information line

# Local variables
_HL_SEP='' # computed separator line
_HL_INFO='' # computed information line
_HL_AT_TOP='true' # whether prompt is at top of the screen
_HL_CMD_NUM=0 # number of commands entered
_HL_CMD_NUM_PREV=-1 # previous number of commands entered, no command if same

# Zsh configuration
setopt PROMPT_SP # always start prompt on new line
setopt PROMPT_SUBST # enable substitutions
autoload -U add-zsh-hook
PROMPT_EOL_MARK='' # remove weird % symbol
ZLE_RPROMPT_INDENT=0 # remove extra space


# Calculate length of string, excluding formatting characters
headline-prompt-len() { # (str, num?)
  # Ref: https://old.reddit.com/r/zsh/comments/cgbm24/multiline_prompt_the_missing_ingredient/
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
headline-repeat-char() { # (char, num)
  # Note: This replaces the "${(pl:$num::$char:)}" expansion
  local result=''
  for (( i = 0; i < $2; i++ )); do
    result+=$1
  done
  echo $result
}

# Guess the exit code meaning
headline-exit-meaning() { # (num)
  # Ref: https://tldp.org/LDP/abs/html/exitcodes.html
  # Ref: https://man7.org/linux/man-pages/man7/signal.7.html
  # Note: These meanings are not standardized
  case $1 in
    126) echo 'Command cannot execute';;
    127) echo 'Command not found';;
    129) echo 'Hangup';;
    130) echo 'Interrupted';;
    131) echo 'Quit';;
    132) echo 'Illegal instruction';;
    133) echo 'Trapped';;
    134) echo 'Aborted';;
    135) echo 'Bus error';;
    136) echo 'Arithmetic error';;
    137) echo 'Killed';;
    138) echo 'User signal 1';;
    139) echo 'Segmentation fault';;
    140) echo 'User signal 2';;
    141) echo 'Pipe error';;
    142) echo 'Alarm';;
    143) echo 'Terminated';;
    *) ;;
  esac
}

# Git command wrapper
headline-git() {
  # TODO is this necessary?
  GIT_OPTIONAL_LOCKS=0 command git "$@"
}

# Get git branch (or hash)
headline-git-branch() {
  local ref
  ref=$(headline-git symbolic-ref --quiet HEAD 2> /dev/null)
  local err=$?
  if [[ $err == 0 ]]; then
    echo ${ref#refs/heads/} # remove "refs/heads/" to get branch
  else # not on a branch
    [[ $err == 128 ]] && return  # not a git repo
    ref=$(headline-git rev-parse --short HEAD 2> /dev/null) || return
    echo ":${ref}" # hash prefixed to distingush from branch
  fi
}

# Get the quantity of each git status
headline-git-status-counts() {
  local -A counts=(
    'STAGED' 0 # staged changes
    'CHANGED' 0 # unstaged changes
    'UNTRACKED' 0 # untracked files
    'BEHIND' 0 # commits behind
    'AHEAD' 0 # commits ahead
    'DIVERGED' 0 # commits diverged
    'STASHED' 0 # stashed files
    'CONFLICTS' 0 # conflicts
    'CLEAN' 1 # clean branch 1=true 0=false
  )

  # Retrieve status
  local raw lines
  raw="$(headline-git status --porcelain -b 2> /dev/null)"
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
          'behind') counts[BEHIND]=$match[2];;
          'ahead') counts[AHEAD]=$match[2];;
          'diverged') counts[DIVERGED]=$match[2];;
        esac
      fi
    done
  fi

  # Process status lines
  for line in $lines; do
    if [[ $line =~ '^##|^!!' ]]; then
      continue
    elif [[ $line =~ '^U[ADU]|^[AD]U|^AA|^DD' ]]; then
      counts[CONFLICTS]=$(( ${counts[CONFLICTS]} + 1 ))
    elif [[ $line =~ '^\?\?' ]]; then
      counts[UNTRACKED]=$(( ${counts[UNTRACKED]} + 1 ))
    elif [[ $line =~ '^[MTADRC] ' ]]; then
      counts[STAGED]=$(( ${counts[STAGED]} + 1 ))
    elif [[ $line =~ '^[MTARC][MTD]' ]]; then
      counts[STAGED]=$(( ${counts[STAGED]} + 1 ))
      counts[CHANGED]=$(( ${counts[CHANGED]} + 1 ))
    elif [[ $line =~ '^ [MTADRC]' ]]; then
      counts[CHANGED]=$(( ${counts[CHANGED]} + 1 ))
    fi
  done

  # Check for stashes
  if $(headline-git rev-parse --verify refs/stash &> /dev/null); then
    counts[STASHED]=$(headline-git rev-list --walk-reflogs --count refs/stash 2> /dev/null)
  fi

  # Update clean flag
  for key val in ${(@kv)counts}; do
    [[ $key == 'CLEAN' ]] && continue
    (( $val > 0 )) && counts[CLEAN]=0
  done

  echo ${(@kv)counts} # key1 val1 key2 val2 ...
}

# Get git status
headline-git-status() {
  local parts=( ${(ps:$HL_TEMPLATE_TOKEN:)HL_CONTENT_TEMPLATE[STATUS]} ) # split on template token
  local style=${${parts[1]##*%\{}%%%\}*} # regex for "%{...%}"
  local -A counts=( $(headline-git-status-counts) )
  (( ${#counts} == 0 )) && return # not a git repo
  local result=''
  for key in $HL_GIT_STATUS_ORDER; do
    if (( ${counts[$key]} > 0 )); then
      if (( ${#HL_GIT_SEP_SYMBOL} != 0 && ${#result} != 0 )); then
        result+="%{$reset%}$HL_BASE_STYLE$HL_LAYOUT_STYLE$HL_GIT_SEP_SYMBOL%{$reset%}$HL_BASE_STYLE%{$style%}"
      fi
      if [[ $key != 'CLEAN' && $HL_GIT_COUNT_MODE == 'on' || ( $HL_GIT_COUNT_MODE == 'auto' && ${counts[$key]} != 1 ) ]]; then
        result+="${counts[$key]}${HL_GIT_STATUS_SYMBOLS[$key]}"
      else
        result+="${HL_GIT_STATUS_SYMBOLS[$key]}"
      fi
    fi
  done
  echo $result
}

# Transfer styles to another string
headline-transfer-styles() { # (str, str)
  local -a src=( ${(@s::)1} ) # source char array
  local -a dest=( ${(@s::)2} ) # destination char array
  local result=''
  local prev=''
  local is_style='false'
  local index=0
  for char in $src; do
    if [[ $prev == '{' || $prev == '}' ]]; then
      prev=$char
      continue
    elif [[ $prev == '%' && $char == '{' ]]; then
      [[ $is_style != 'true' ]] && result+='%{'
      is_style='true'
    elif [[ $prev == '%' && $char == '}' ]]; then
      [[ $is_style == 'true' ]] && result+='%}'
      is_style='false'
    elif [[ $is_style == 'true' ]]; then
      result+=$prev
    else
      result+=${dest[$index]}
      (( index += 1 ))
    fi
    prev=$char
  done
  result+=${dest[$index]}
  echo $result

  # TODO use regex... why does this suck so much? can't match multiple?
  # if [[ $1 =~ '%{([^%]*)%}' ]]; then
  #   echo $MBEGIN $MEND $MATCH
  #   echo $mbegin $mend $match # expect arrays?
  # fi
}


# Handle Ctrl+L press
zle -N headline-clear-screen
bindkey '^L' headline-clear-screen
headline-clear-screen() {
  _HL_AT_TOP='true'
  _HL_INFO='' # ensure info line will print

  # Hide cursor and clear screen
  print -nr "$cursor_hide$cursor_to_top_left_corner$clear_entire_screen"

  # Update and print
  for function in $precmd_functions; do
    $function
  done
  zle .reset-prompt # re-print $PROMPT and $RPROMPT

  # Show cursor
  print -nr "$cursor_show"
}

# Before executing command
add-zsh-hook preexec headline-preexec
headline-preexec() {
  (( _HL_CMD_NUM++ ))
  # TODO better way of knowing the prompt is at the top of the terminal ?
  if [[ $2 == 'clear' ]]; then
    _HL_AT_TOP='true'
    _HL_INFO='' # ensure info line will print
  fi
}

# Before prompting
add-zsh-hook precmd headline-precmd
headline-precmd() {
  local -i err=$?
  local -i trunc_initial_length=$(( $HL_TRUNC_INITIAL + ${#HL_TRUNC_SYMBOL} ))
  local -i trunc_removal_length=$(( $HL_TRUNC_REMOVAL + ${#HL_TRUNC_SYMBOL} ))

  # Acquire contents
  local -A contents
  local -A content_lengths # length of each content (without style)
  local -i content_length=0 # total length of content
  for key val in "${(@kv)HL_CONTENT_SOURCE}"; do
    content_lengths[$key]=0
    (( $COLUMNS < ${HL_COLS_REMOVAL[$key]:-0} )) && continue # omit segment
    contents[$key]=$(eval ${=val})
    local -i length=$(headline-prompt-len ${contents[$key]:-''} 999)
    (( content_length += $length )); content_lengths[$key]=$length
  done

  # Compute layout lengths
  local -A layouts
  local -A layout_lengths # length of each layout (without style)
  local -i layout_length=0 # total length of layout
  local -A first_layout_lengths # length of each first layout (without style)
  for key val in "${(@kv)HL_LAYOUT_TEMPLATE}"; do
    layout_lengths[$key]=0
    local -i length=$(headline-prompt-len "$val$HL_CONTENT_TEMPLATE[$key]" 999)
    local -i first_length=$(headline-prompt-len "$HL_LAYOUT_FIRST[$key]$HL_CONTENT_TEMPLATE[$key]" 999)
    if [[ ${key[1]} != '_' ]]; then
      (( content_lengths[$key] <= 0 )) && continue # skip omitted segment
      (( length -= ${#HL_TEMPLATE_TOKEN} * 2 )) # subtract length of tokens
      (( first_length -= ${#HL_TEMPLATE_TOKEN} * 2 )) # subtract length of tokens
    fi
    layouts[$key]=$val
    (( layout_length += $length )); layout_lengths[$key]=$length
    (( ${+HL_LAYOUT_FIRST[$key]} )) && first_layout_lengths[$key]=$first_length
  done

  # Compute target truncation length
  local -i target_length=$content_length
  for key in $HL_LAYOUT_ORDER; do
    (( ! $HL_TRUNC_ORDER[(Ie)$key] )) && continue # no truncation specified
    (( $trunc_initial_length >= $content_lengths[$key] )) && continue # already short enough
    (( target_length -= $content_lengths[$key] - $trunc_initial_length ))
  done

  # Update first segment
  for key in $HL_LAYOUT_ORDER; do
    [[ $key == '_PRE' ]] && continue # skip special segment
    (( content_lengths[$key] <= 0 && layout_lengths[$key] <= 0 )) && continue # skip omitted segment
    if (( ${+HL_LAYOUT_FIRST[$key]} )); then
      layouts[$key]=$HL_LAYOUT_FIRST[$key]
      (( layout_length -= $layout_lengths[$key] - $first_layout_lengths[$key] ))
      layout_lengths[$key]=$first_layout_lengths[$key]
    fi
    break
  done

  # Remove segments as needed
  for key in $HL_TRUNC_ORDER; do
    (( content_lengths[$key] <= 0 )) && continue # already removed
    local -i remove=$(( $content_lengths[$key] < $trunc_initial_length ? $content_lengths[$key] : $trunc_initial_length ))
    local -i offset=$(( $remove < $trunc_removal_length ? 0 : $remove - $trunc_removal_length ))
    (( $target_length + $layout_length - $offset <= $COLUMNS )) && break # done removing
    (( target_length -= $remove ))
    contents[$key]=''; (( content_length -= $content_lengths[$key] )); content_lengths[$key]=0
    layouts[$key]=''; (( layout_length -= $layout_lengths[$key] )); layout_lengths[$key]=0

    # Update first segment
    for key in $HL_LAYOUT_ORDER; do
      [[ $key == '_PRE' ]] && continue # skip special segment
      (( content_lengths[$key] <= 0 && layout_lengths[$key] <= 0 )) && continue # skip omitted segment
      if (( ${+HL_LAYOUT_FIRST[$key]} )); then
        layouts[$key]=$HL_LAYOUT_FIRST[$key]
        (( layout_length -= $layout_lengths[$key] - $first_layout_lengths[$key] ))
        layout_lengths[$key]=$first_layout_lengths[$key]
      fi
      break
    done
  done

  # Truncate segments to initial length
  for key in $HL_TRUNC_ORDER; do
    (( content_lengths[$key] <= 0 )) && continue # segment removed
    local -i excess=$(( $content_length + $layout_length - $COLUMNS ))
    (( $excess <= 0 )) && break # done truncating
    local -i removeable=$(( $content_lengths[$key] - $trunc_initial_length ))
    (( $removeable <= 0 )) && continue # already short enough
    local -i remove=$(( ( $excess < $removeable ? $excess : $removeable ) ))
    (( content_length -= $remove ))
    content_lengths[$key]=$(( $content_lengths[$key] - $remove ))
    contents[$key]="$HL_TRUNC_SYMBOL${contents[$key]:$(( $remove + ${#HL_TRUNC_SYMBOL} ))}"
  done

  # Truncate segment to minimum length
  for key in $HL_TRUNC_ORDER; do
    (( content_lengths[$key] <= 0 )) && continue # segment removed
    local -i excess=$(( $content_length + $layout_length - $COLUMNS ))
    (( $excess <= 0 )) && break # done truncating
    (( content_length -= $excess ))
    content_lengths[$key]=$(( $content_lengths[$key] - $excess ))
    contents[$key]="$HL_TRUNC_SYMBOL${contents[$key]:$(( excess + ${#HL_TRUNC_SYMBOL} ))}"
  done

  # Build spacer
  local -i remainder=$(( $COLUMNS - $content_length - $layout_length ))
  if (( $remainder > 0 )); then
    contents[_SPACER]="$(headline-repeat-char "$HL_SPACE_CHAR" $(( $remainder + $layout_lengths[_SPACER] )) )"
  fi

  # Assemble segments
  local information='' # the styled information line
  for key in $HL_LAYOUT_ORDER; do
    local segment=''; local segment_sep=''
    if [[ ${key[1]} == '_' && ${#contents[$key]} == 0 ]]; then # special segment without content (ex: _PRE, _POST)
      segment="${layouts[$key]}"; segment_sep=$segment
    elif [[ ${key[1]} == '_' && ${#contents[$key]} != 0 ]]; then # special segment with generated content (ex: _SPACER)
      segment="${contents[$key]}"; segment_sep=$segment
    elif [[ ${key[1]} != '_' && ${#contents[$key]} != 0 ]]; then # normal segment with content
      segment="${HL_CONTENT_TEMPLATE[$key]/$HL_TEMPLATE_TOKEN/$contents[$key]}"
      segment="%{$reset%}$HL_BASE_STYLE$segment%{$reset%}$HL_BASE_STYLE$HL_LAYOUT_STYLE"
      segment="${layouts[$key]/$HL_TEMPLATE_TOKEN/$segment}"
    else # normal segment without content
      continue
    fi
    information+="$HL_BASE_STYLE$HL_LAYOUT_STYLE$segment%{$reset%}"
  done

  # Assemble separator
  local separator=$(headline-repeat-char "${HL_SEP[_LINE]}" $(( $COLUMNS - ${#HL_SEP[_PRE]} - ${#HL_SEP[_POST]} )) )
  separator=$(headline-transfer-styles "$information" "${HL_SEP[_PRE]}$separator${HL_SEP[_POST]}")
  separator="${separator//"%}"/"%}$HL_SEP_STYLE"}"

  # Prepare cursor
  local overwrite='false'
  if [[ $HL_OVERWRITE == 'on' && $_HL_CMD_NUM == $_HL_CMD_NUM_PREV ]]; then
    overwrite='true'
    print -nr "$cursor_hide"
    print -nr "$cursor_up" # to prompt line
    (( ${#HL_OUTPUT_INFO} )) && print -nr "$cursor_up" # to info line
    (( ${#HL_OUTPUT_SEP} )) && print -nr "$cursor_up" # to separator line
    if [[ $HL_SEP_MODE == 'auto' && ! $HL_OUTPUT_SEP ]]; then
      _HL_AT_TOP='true' # deduce that we were at top last time
    fi
    print -nr "$cursor_show"
  fi

  # Error line
  if [[ $err != 0 && ($HL_ERR_MODE == 'on' || $HL_ERR_MODE == 'detail') && $overwrite != 'true' ]]; then
    local message=$err
    if [[ $HL_ERR_MODE == 'detail' ]]; then
      local meaning=$(headline-exit-meaning $err)
      (( ${#meaning} > 0 )) && message+="${HL_ERR_DETAIL_TEMPLATE/$HL_TEMPLATE_TOKEN/$meaning}%{$reset%}"
    fi
    print -rP "${HL_ERR_TEMPLATE/$HL_TEMPLATE_TOKEN/$message}%{$reset%}"
  fi

  # Separator line
  if [[ $HL_SEP_MODE == 'on' || ($HL_SEP_MODE == 'auto' && $_HL_AT_TOP != 'true') ]]; then
    HL_OUTPUT_SEP=$separator
    [[ $HL_PRINT_MODE == 'precmd' ]] && print -rP "$HL_OUTPUT_SEP"
  else
    HL_OUTPUT_SEP=''
  fi
  _HL_SEP=$separator

  # Information line
  if [[ $HL_INFO_MODE == 'on' || ($HL_INFO_MODE == 'auto' && $information != $_HL_INFO) || $overwrite == 'true' ]]; then
    HL_OUTPUT_INFO=$information
    [[ $HL_PRINT_MODE == 'precmd' ]] && print -rP "$HL_OUTPUT_INFO"
  else
    HL_OUTPUT_INFO=''
  fi
  _HL_INFO=$information

  # Prompt
  if [[ $HL_PRINT_MODE == 'prompt' ]]; then
    PROMPT='$('
    (( ${#HL_OUTPUT_SEP} )) && PROMPT+='print -rP "$HL_OUTPUT_SEP"; '
    (( ${#HL_OUTPUT_INFO} )) && PROMPT+='print -rP "$HL_OUTPUT_INFO"; '
    PROMPT+='print -rP "$HL_PROMPT")'
  else
    PROMPT=$HL_PROMPT
  fi

  # Right prompt
  if [[ $HL_CLOCK_MODE == 'on' ]]; then
    RPROMPT='${HL_CLOCK_TEMPLATE/$HL_TEMPLATE_TOKEN/$(eval ${=HL_CLOCK_SOURCE})}%{$reset%}$HL_RPROMPT'
  else
    RPROMPT=$HL_RPROMPT
  fi

  _HL_CMD_NUM_PREV=$_HL_CMD_NUM
  _HL_AT_TOP='false'
}
