# Customization
Take a look in the `headline.zsh-theme` file to see all the customization variables (they start [around line 70](../headline.zsh-theme#L70)). This documentation is non-exhaustive.

<br>


## General
### Setting Variables
You can edit the variables in the theme file directly, or set the Headline variables in your `~/.zshrc` after the theme is sourced. *Variables set before the theme is sourced are ignored.*

### Styles
By "styles" I mean [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters): non-printed sequences that specify colors and formatting. I have aliased all the common SGR codes at the beginning of the file, so you can use `$red` instead of `$'\e[31m'`.

* Formatting – `$reset`, `$bold`, `$faint`, `$italic`, `$underline`, `$invert`

* Foreground colors – `$black`, `$red`, `$green`, `$yellow`, `$blue`, `$magenta`, `$cyan`, `$white`, `$light_black`, `$light_red`, `$light_green`, `$light_yellow`, `$light_blue`, `$light_magenta`, `$light_cyan`, `$light_white`

* Background colors – Same as the foreground colors but with `_back` on the end, such as `$red_back`.

<br>


## Separator Line
### Toggle Separator
*`HEADLINE_LINE_MODE`*  
Whether to print the separator line above the prompt.
* `on` – always print the line
* `auto` – print the line, but not on the first prompt or after the `clear` command (this feature isn't complete)
* `off` – don't print the line

### Styles
Styles to apply to each segment of the separator line.
| Variable                        | Default         |
|---------------------------------|-----------------|
| *`HEADLINE_STYLE_JOINT_LINE`*   | `$light_black`  |
| *`HEADLINE_STYLE_USER_LINE`*    | `$bold$red`     |
| *`HEADLINE_STYLE_HOST_LINE`*    | `$bold$yellow`  |
| *`HEADLINE_STYLE_PATH_LINE`*    | `$bold$blue`    |
| *`HEADLINE_STYLE_BRANCH_LINE`*  | `$bold$cyan`    |
| *`HEADLINE_STYLE_STATUS_LINE`*  | `$bold$magenta` |

<br>


## Information Line
### Toggle Segments
*`HEADLINE_DO_USER`, `HEADLINE_DO_HOST`, `HEADLINE_DO_PATH`, `HEADLINE_DO_GIT_BRANCH`, `HEADLINE_DO_GIT_STATUS`*  
Whether to print each segment of prompt
* `true` – print segment
* `false` – don't print segment or associated joints

### Symbols
*`HEADLINE_USER_PREFIX`, `HEADLINE_HOST_PREFIX`, `HEADLINE_PATH_PREFIX`, `HEADLINE_BRANCH_PREFIX`*  
Symbols to prepend to each segment of info line. The symbols are from your font. More details in [Terminal Setup](Terminal-Setup.md).

### Styles
Styles to apply to each segment. The default style applies to the entire information line, although the other styles take precedence.
| Variable                   | Default         |
|----------------------------|-----------------|
| *`HEADLINE_STYLE_JOINT`*   | `$light_black`  |
| *`HEADLINE_STYLE_USER`*    | `$bold$red`     |
| *`HEADLINE_STYLE_HOST`*    | `$bold$yellow`  |
| *`HEADLINE_STYLE_PATH`*    | `$bold$blue`    |
| *`HEADLINE_STYLE_BRANCH`*  | `$bold$cyan`    |
| *`HEADLINE_STYLE_STATUS`*  | `$bold$magenta` |
| *`HEADLINE_STYLE_DEFAULT`* | (none)          |

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

By default, `HEADLINE_USER_BEGIN` is `=> ` when `IS_SSH` is `0` (true).

### Print Mode
*`HEADLINE_INFO_MODE`*  
Whether info line is in `PROMPT` or printed by `precmd`. This option exists because I can't figure out how to solve both problems at once.
* `precmd` – window resize works properly, but Ctrl+L won't print the info line
* `prompt` – Ctrl+L works properly, but window resize eats previous output

<br>


## Git Status
### Toggle Counts
*`HEADLINE_DO_GIT_STATUS_COUNTS`*  
Whether to show count of each status. It can make the status segment a bit cluttery, so also consider setting the `HEADLINE_STATUS_TO_STATUS` joint character
* `true` – show counts
* `false` – don't show counts

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

### Function Override
The Git status information comes from the function `headline_git_status`. To use your own Git status function, such as `my_git_status`, you can re-define `headline_git_status` in your `~/.zshrc` to call it like so:
```
headline_git_status() { echo $(my_git_status) }
```

<br>


## Prompt Line
*`HEADLINE_PROMPT`*  
Prompt line string, which by default shows `$` normally and `#` for root. Supports [Zsh prompt expansion](https://zsh.sourceforge.io/Doc/Release/Prompt-Expansion.html), so you could use `"%#"` to get `%` normally and `#` for root.

<br>


## Screenshots
> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/customization_demo.png" width="600"/>
>
> A sampling of the available customization variables.

<br>
