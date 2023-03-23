# Customization
Take a look in the `headline.zsh-theme` file to see all the customization variables (they start [around line 70](../headline.zsh-theme#L70)). This documentation is non-exhaustive.

For sample configurations see [Examples](#examples)

<br>


## General
### Setting Variables
You can edit the customization variables in the theme file directly, or set them in your `~/.zshrc` after the theme is sourced.

*You must source the theme before setting customization variables!*

### Booleans
The string "true" is considered *true*, all other values are false.

> Example: `HEADLINE_DO_ERR=true`

### Styles
By "styles" I mean [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters): non-printed sequences that specify colors and formatting. I have aliased all the common SGR codes at the beginning of the file, so you can use `$red` instead of `$'\e[31m'`.

* Formatting – `$reset`, `$bold`, `$faint`, `$italic`, `$underline`, `$invert`

* Foreground colors – `$black`, `$red`, `$green`, `$yellow`, `$blue`, `$magenta`, `$cyan`, `$white`, `$light_black`, `$light_red`, `$light_green`, `$light_yellow`, `$light_blue`, `$light_magenta`, `$light_cyan`, `$light_white`

* Background colors – Same as the foreground colors but with `_back` on the end, such as `$red_back`.

<br>


## Information Line
The core of the prompt.
```
<user> @ <host>: <path> | <branch> [<status>]
```

### Data sources
*`HEADLINE_USER_CMD`, `HEADLINE_HOST_CMD`, `HEADLINE_PATH_CMD`, `HEADLINE_GIT_BRANCH_CMD`, `HEADLINE_GIT_STATUS_CMD`*  
Commands that are eval'd to obtain each segment's content. Enclose in single quotes. Use empty string to disable a segment.

### Symbols
*`HEADLINE_USER_PREFIX`, `HEADLINE_HOST_PREFIX`, `HEADLINE_PATH_PREFIX`, `HEADLINE_BRANCH_PREFIX`*  
Symbols to prepend to each segment of info line. The symbols must be included with your font. More details in [Terminal Setup](Terminal-Setup.md).

### Joints
The connector strings between information segments.
| Variable                      | Default  |
|-------------------------------|----------|
| *`HEADLINE_USER_BEGIN`*       | (none)   |
| *`HEADLINE_USER_TO_HOST`*     | `' @ '`  |
| *`HEADLINE_HOST_TO_PATH`*     | `': '`   |
| *`HEADLINE_PATH_TO_BRANCH`*   | `' \| '` |
| *`HEADLINE_PATH_TO_PAD`*      | (none)   |
| *`HEADLINE_PAD_TO_BRANCH`*    | (none)   |
| *`HEADLINE_BRANCH_TO_STATUS`* | `' ['`   |
| *`HEADLINE_STATUS_TO_STATUS`* | (none)   |
| *`HEADLINE_STATUS_END`*       | `']'`    |

### Padding Character
*`HEADLINE_PAD_CHAR`*  
Character that repeats to pad between path and branch, space by default.

### Truncation Symbol
*`HEADLINE_TRUNC_PREFIX`*  
Symbol used when path or branch is truncated, `...` by default.

### Styles
Styles applied to each segment. The default style applies to the entire information line, although the other styles take precedence.
| Variable                   | Default         |
|----------------------------|-----------------|
| *`HEADLINE_STYLE_JOINT`*   | `$light_black`  |
| *`HEADLINE_STYLE_USER`*    | `$bold$red`     |
| *`HEADLINE_STYLE_HOST`*    | `$bold$yellow`  |
| *`HEADLINE_STYLE_PATH`*    | `$bold$blue`    |
| *`HEADLINE_STYLE_BRANCH`*  | `$bold$cyan`    |
| *`HEADLINE_STYLE_STATUS`*  | `$bold$magenta` |
| *`HEADLINE_STYLE_DEFAULT`* | (none)          |

By default, `HEADLINE_USER_BEGIN` is `=>` when `IS_SSH` is `0` (true).

### Print Mode
*`HEADLINE_INFO_MODE`*  
Whether info line is in `PROMPT` or printed by `precmd`. This option exists because I can't figure out how to solve both problems at once.
* `precmd` – window resize works properly, but Ctrl+L won't print the info line (default)
* `prompt` – Ctrl+L works properly, but window resize eats previous output

<br>


## Separator Line
A line above the prompt with matching colors.
```
_______________________________________________
```

### Separator Mode
*`HEADLINE_LINE_MODE`*  
Whether to print the separator line above the prompt.
* `on` – always print the line (default)
* `auto` – print the line, but not on the first prompt or after the `clear` command (this feature isn't complete)
* `off` – don't print the line

### Line Character
*`HEADLINE_LINE_CHAR`*  
Character that repeats to build separator line, `_` by default.

### Styles
Styles applied to each segment of the separator line.
| Variable                        | Default         |
|---------------------------------|-----------------|
| *`HEADLINE_STYLE_JOINT_LINE`*   | `$light_black`  |
| *`HEADLINE_STYLE_USER_LINE`*    | `$bold$red`     |
| *`HEADLINE_STYLE_HOST_LINE`*    | `$bold$yellow`  |
| *`HEADLINE_STYLE_PATH_LINE`*    | `$bold$blue`    |
| *`HEADLINE_STYLE_BRANCH_LINE`*  | `$bold$cyan`    |
| *`HEADLINE_STYLE_STATUS_LINE`*  | `$bold$magenta` |

<br>


## Git Status
Status of the current git branch represented by symbols.
```
[+!?↓↑↕*✘]
```

### Status Characters
Characters used to represent each Git status.
| Variable                   | Default | Meaning          |
|----------------------------|---------|------------------|
| *`HEADLINE_GIT_STAGED`*    | `+`     | staged changes   |
| *`HEADLINE_GIT_CHANGED`*   | `!`     | unstaged changes |
| *`HEADLINE_GIT_UNTRACKED`* | `?`     | untracked files  |
| *`HEADLINE_GIT_BEHIND`*    | `↓`     | commits behind   |
| *`HEADLINE_GIT_AHEAD`*     | `↑`     | commits ahead    |
| *`HEADLINE_GIT_DIVERGED`*  | `↕`     | commits diverged |
| *`HEADLINE_GIT_STASHED`*   | `*`     | stashed files    |
| *`HEADLINE_GIT_CONFLICTS`* | `✘`     | conflicts        |
| *`HEADLINE_GIT_CLEAN`*     | (none)  | clean branch     |

### Toggle Counts
*`HEADLINE_DO_GIT_STATUS_COUNTS`*  
Whether to show count of each status. It can make the status segment a bit cluttery, so also consider setting the `HEADLINE_STATUS_TO_STATUS` joint character.
* `true` – show counts
* `false` – don't show counts (default)

> Example: no counts `+!?`, with counts `3+1!2?`, and with joint `3+|1!|2?`

### Toggle Single Count
*`HEADLINE_DO_GIT_STATUS_OMIT_ONE`*  
Whether to show count for a status when that count is one (must have `HEADLINE_DO_GIT_STATUS_COUNTS` set `true`).
* `true` – omit the count when it is 1
* `false` – show count even when it is 1 (default)

> Example: counts `3+1!2?`, with omit one `3+!2?`, and with joint `3+|!|2?`

<br>


## Prompt Line
Where commands are entered.
```
$ 
```
### Normal Prompt
*`HEADLINE_PROMPT`*  
Prompt line string, which by default shows `$` normally and `#` for root. Supports [Zsh prompt expansion](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html), so anything you would assign to `PROMPT` should work here too.

> Example: `HEADLINE_PROMPT="%#"` shows `%` normally and `#` for root (the Zsh default)

### Right Prompt
*`HEADLINE_RPROMPT`*  
Optional prompt at right of screen, none by default.

<br>


## Clock
The current time.
```
hh:mm:ss pp
```

*HINT:* The clock shows the time that the prompt was printed. If you want the clock to stay current by re-printing every second, add `TMOUT=1; TRAPALRM () { zle reset-prompt }` to your `~/.zshrc`. Note that this only works properly when `HEADLINE_INFO_MODE` is set to the default value `precmd`.

### Toggle Clock
*`HEADLINE_DO_CLOCK`*  
Whether to show the clock in `RPROMPT`.
* `true` – show clock
* `false` – don't show clock (default)

### Style
*`HEADLINE_STYLE_CLOCK`*  
Style to apply to the clock, `$faint` by default.

### Format
*`HEADLINE_CLOCK_FORMAT`*  
Format of the clock, `%l:%M:%S %p` by default. Use `%+` for complete date and time. See `man strftime` for details.

<br>


## Exit Code
The code returned by the previous command.
```
→ <code> (<meaning>)
```

*HINT:* To add or change the messages associated with exit codes, edit the `headline_exit_meaning()` function (it's just a switch statement).

### Toggle Exit Code
*`HEADLINE_DO_ERR`*  
Whether to show non-zero exit codes.
* `true` – show exit codes
* `false` – don't show exit codes (default)

### Toggle Meaning
*`HEADLINE_DO_ERR_INFO`*  
Whether to show guessed meaning alongside exit code (must have `HEADLINE_DO_ERR` set `true`).
* `true` – show exit code meaning (default)
* `false` – don't show exit code meaning

### Prefix
*`HEADLINE_ERR_PREFIX`*  
String to put ahead of exit code, `→` by default.

### Style
*`HEADLINE_STYLE_ERR`*  
Style applied to exit code line, `$italic$faint` by default.

<br>


## Examples
Some sample configurations for inspiration (with screenshots).

### Compact
Hides separator line and extra spaces between info segments.

<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/config-compact.png" width="600"/>

```sh
HEADLINE_USER_TO_HOST='@'
HEADLINE_HOST_TO_PATH=':'
HEADLINE_PATH_TO_BRANCH='|'
HEADLINE_BRANCH_TO_STATUS='['
HEADLINE_TRUNC_PREFIX='…'
HEADLINE_LINE_MODE=off
```

### Kebab
Hides separator line and uses `-` between info segments.

<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/config-kebab.png" width="600"/>

```sh
HEADLINE_USER_BEGIN='--'
HEADLINE_USER_TO_HOST='-'
HEADLINE_HOST_TO_PATH='-'
HEADLINE_PATH_TO_BRANCH='-'
HEADLINE_PAD_TO_BRANCH='-'
HEADLINE_BRANCH_TO_STATUS='-'
HEADLINE_STATUS_END='--'
HEADLINE_PAD_CHAR='-'
HEADLINE_TRUNC_PREFIX='…'
HEADLINE_LINE_MODE=off
```

### Standard
Shows exit codes (when not 0), clock, and git status counts (when not 1). Moarram uses this configuration.

<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/config-standard.png" width="600"/>

```sh
HEADLINE_STATUS_TO_STATUS='|'
HEADLINE_LINE_MODE=auto
HEADLINE_DO_GIT_STATUS_COUNTS=true
HEADLINE_DO_GIT_STATUS_OMIT_ONE=true
HEADLINE_DO_ERR=true
HEADLINE_DO_CLOCK=true
```

### Verbose
Shows exit codes (when not 0), full time and date, git status counts, info segment symbols, and words between info segments.

<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/config-verbose.png" width="600"/>

```sh
HEADLINE_USER_PREFIX=' '
HEADLINE_HOST_PREFIX=' '
HEADLINE_PATH_PREFIX=' '
HEADLINE_BRANCH_PREFIX=' '
HEADLINE_USER_TO_HOST=' at '
HEADLINE_HOST_TO_PATH=' in '
HEADLINE_PATH_TO_BRANCH=' on '
HEADLINE_PAD_TO_BRANCH=' on '
HEADLINE_BRANCH_TO_STATUS=' ('
HEADLINE_STATUS_TO_STATUS='|'
HEADLINE_STATUS_END=')'
HEADLINE_LINE_MODE=auto
HEADLINE_DO_GIT_STATUS_COUNTS=true
HEADLINE_DO_ERR=true
HEADLINE_DO_CLOCK=true
HEADLINE_CLOCK_FORMAT='%+'
```

### *Yours?*
*Let me know if you'd like to share your setup here!*
