#!/bin/zsh
# To install, source this file from your .zshrc file



# ------------------------------------------------------------------------------
# Customization

# Default flags
HEADLINE_DO_GIT_STATUS_NUMS='false'

# Git status characters
HEADLINE_PRE_GIT_STAGED='+'
HEADLINE_PRE_GIT_CONFLICTS='✘'
HEADLINE_PRE_GIT_CHANGED='!'
HEADLINE_PRE_GIT_UNTRACKED='?'
HEADLINE_PRE_GIT_BEHIND='↓'
HEADLINE_PRE_GIT_AHEAD='↑'
HEADLINE_PRE_GIT_CLEAN='' # consider "✔"

# ------------------------------------------------------------------------------



# A: finds the absolute path, even if this is symlinked
# h: equivalent to dirname
# see documentation at http://linux.die.net/man/1/zshexpn
export __GIT_PROMPT_DIR=${0:A:h}

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
		if [ "$GIT_BEHIND" -ne '0' ]; then
			STATUS="$STATUS$HEADLINE_PRE_GIT_BEHIND"
			if [ "$HEADLINE_DO_GIT_STATUS_NUMS" = 'true' ]; then STATUS="$STATUS$GIT_BEHIND" fi
		fi
		if [ "$GIT_AHEAD" -ne '0' ]; then
			STATUS="$STATUS$HEADLINE_PRE_GIT_AHEAD"
			if [ "$HEADLINE_DO_GIT_STATUS_NUMS" = 'true' ]; then STATUS="$STATUS$GIT_AHEAD" fi
		fi
		if [ "$GIT_CHANGED" -eq '0' ] && [ "$GIT_CONFLICTS" -eq '0' ] && [ "$GIT_STAGED" -eq '0' ] && [ "$GIT_UNTRACKED" -eq '0' ]; then
			STATUS="$STATUS$HEADLINE_PRE_GIT_CLEAN"
		else
			STATUS="$STATUS"
			if [ "$GIT_STAGED" -ne '0' ]; then
				STATUS="$STATUS$HEADLINE_PRE_GIT_STAGED"
				if [ "$HEADLINE_DO_GIT_STATUS_NUMS" = 'true' ]; then STATUS="$STATUS$GIT_STAGED" fi
			fi
			if [ "$GIT_CONFLICTS" -ne '0' ]; then
				STATUS="$STATUS$HEADLINE_PRE_GIT_CONFLICTS"
				if [ "$HEADLINE_DO_GIT_STATUS_NUMS" = 'true' ]; then STATUS="$STATUS$GIT_CONFLICTS" fi
			fi
			if [ "$GIT_CHANGED" -ne '0' ]; then
				STATUS="$STATUS$HEADLINE_PRE_GIT_CHANGED"
				if [ "$HEADLINE_DO_GIT_STATUS_NUMS" = 'true' ]; then STATUS="$STATUS$GIT_CHANGED" fi
			fi
			if [ "$GIT_UNTRACKED" -ne '0' ]; then
				STATUS="$STATUS$HEADLINE_PRE_GIT_UNTRACKED"
				if [ "$HEADLINE_DO_GIT_STATUS_NUMS" = 'true' ]; then STATUS="$STATUS$GIT_UNTRACKED" fi
			fi
			STATUS="$STATUS"
		fi
		echo "$STATUS"
	fi
}
