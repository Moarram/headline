# Moarram's ZSH Theme
A responsive ZSH theme featuring Git status information and a colored line above the prompt.


## Screenshots
Screenshots of theme in [iTerm2](https://iterm2.com/index.html). Using [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) for connected line and fancy icons.

> ![light theme screenshot](https://raw.githubusercontent.com/moarram/moarram.zsh-theme/main/.github/images/zsh_theme_light.png)
> Status showing `+` for staged changes, `!` for unstaged changes, and `?` for untracked files (configurable).

> ![brown theme screenshot](https://raw.githubusercontent.com/moarram/moarram.zsh-theme/main/.github/images/zsh_theme_brown.png)
> Optional icons, special font needed.

> ![dark theme screenshot](https://raw.githubusercontent.com/moarram/moarram.zsh-theme/main/.github/images/zsh_theme_dark.png)
> Path truncated to fit in available space.


## Installation
### Dependencies
* [ZSH](https://zsh.sourceforge.io/) – required
* [Git](https://git-scm.com/) – for installation (optional)
* [Python 3](https://www.python.org/) – for [Git status](https://github.com/olivierverdier/zsh-git-prompt) retrieval (optional)

### Standard Install
Clone the repository.
```
git clone https://github.com/moarram/moarram.zsh-theme.git
```

In your `~/.zshrc`, source the `moarram.zsh-theme` file in the repository.
```
source your/path/to/moarram.zsh-theme
```

### [Antigen](https://github.com/zsh-users/antigen) Install
Add the following line before `antigen apply` in your `~/.zshrc`.
```
antigen bundle moarram/moarram.zsh-theme@main
```

### Minimal Install (No Python)
Just download the `moarram.zsh-theme` file and source it in your `~/.zshrc`. The prompt is faster and contained in a single file, but without the Git status (branch still shows).

### Other Installs
I haven't tested with other frameworks. If you have success with another install method, let me know so I can add it to the README.

If you want Git status info, you need `deps/zsh-git-status.sh` and `deps/gitstatus.py` available to `moarram.zsh-theme`. You can use the `moarram.zsh-theme` by itself, but it won't have the Git status info.


## Features
### Separator Line
A line above the prompt info text with matching colors. It can be disabled if you want.

### Information Line
Shows the user, host, path, git branch, and git status. This line is responsive, meaning it won't overflow when it gets too long. Each part of the information line can be individually styled using [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (which are conveniently aliased in the theme file).

### Git Status
By default, the Git status info shows `+` for staged changes, `!` for unstaged changes, `?` for untracked files, `↓` for commits behind, `↑` for commits ahead, `✘` for conflicts, and nothing when the branch is clean. All these characters can be customized.

### Prompt
The prompt shows `$` normally and `#` for root. This can be customized by changing `PROMPT` (if you prefer `%` for example). 


## Customization
Use the variables in the `moarram.zsh-theme` file to customize colors, styles, and symbols. I recommend defining the variables in your `~/.zshrc` after the theme is sourced. 
