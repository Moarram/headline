#!/bin/zsh
# To install, source this file from your .zshrc file

# see documentation at http://linux.die.net/man/1/zshexpn
# A: finds the absolute path, even if this is symlinked
# h: equivalent to dirname
export __GIT_PROMPT_DIR=${0:A:h}

# Allow for functions in the prompt.
setopt PROMPT_SUBST

autoload -U add-zsh-hook

add-zsh-hook chpwd chpwd_update_git_vars
add-zsh-hook preexec preexec_update_git_vars
add-zsh-hook precmd precmd_update_git_vars

## Function definitions
function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_PROMPT_GIT_CACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

function chpwd_update_git_vars() {
    update_current_git_vars
}

function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

	local git_status_script="$__GIT_PROMPT_DIR/gitstatus.py"
	local git_status=`python ${git_status_script} 2>/dev/null`
	__CURRENT_GIT_STATUS=("${(@s: :)git_status}")

	GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
	GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
	GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
	GIT_STAGED=$__CURRENT_GIT_STATUS[4]
	GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
	GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
	GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
}

git_prompt_branch() {
	precmd_update_git_vars
	if [ -n "$__CURRENT_GIT_STATUS" ]; then
		STATUS="$GIT_BRANCH"
		echo "$STATUS"
	fi
}

git_prompt_status() {
	precmd_update_git_vars
	if [ -n "$__CURRENT_GIT_STATUS" ]; then
		if [ "$GIT_BEHIND" -ne "0" ]; then
			STATUS="$STATUS$ZSH_PROMPT_GIT_BEHIND" #$(( $GIT_BEHIND == 1 ? '' : $GIT_BEHIND ))"
		fi
		if [ "$GIT_AHEAD" -ne "0" ]; then
			STATUS="$STATUS$ZSH_PROMPT_GIT_AHEAD" #$(( $GIT_AHEAD == 1 ? '' : $GIT_AHEAD ))"
		fi
		if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] && [ "$GIT_UNTRACKED" -eq "0" ]; then
			STATUS="$STATUS$ZSH_PROMPT_GIT_CLEAN"
		else
			STATUS="$STATUS"
			if [ "$GIT_STAGED" -ne "0" ]; then
				STATUS="$STATUS$ZSH_PROMPT_GIT_STAGED"
			fi
			if [ "$GIT_CONFLICTS" -ne "0" ]; then
				STATUS="$STATUS$ZSH_PROMPT_GIT_CONFLICTS"
			fi
			if [ "$GIT_CHANGED" -ne "0" ]; then
				STATUS="$STATUS$ZSH_PROMPT_GIT_CHANGED"
			fi
			if [ "$GIT_UNTRACKED" -ne "0" ]; then
				STATUS="$STATUS$ZSH_PROMPT_GIT_UNTRACKED"
			fi
			STATUS="$STATUS"
		fi
		echo "$STATUS"
	fi
}

# Default values for the appearance of the prompt. Configure at will.
ZSH_PROMPT_GIT_BRANCH="%B%F{5}"
ZSH_PROMPT_GIT_STAGED="%F{1}%{●%G%}"
ZSH_PROMPT_GIT_CONFLICTS="%F{1}%{✖%G%}"
ZSH_PROMPT_GIT_CHANGED="%F{4}%{✚%G%}"
ZSH_PROMPT_GIT_BEHIND="%{↓%G%}"
ZSH_PROMPT_GIT_AHEAD="%{↑%G%}"
ZSH_PROMPT_GIT_UNTRACKED="%{…%G%}"
ZSH_PROMPT_GIT_CLEAN="%B%F{2}%{✔%G%}"
