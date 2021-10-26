# Moarram's ZSH Theme
A ZSH theme featuring Git status information and a colored line above the prompt.


## Screenshots
Screenshots of theme in [iTerm2](https://iterm2.com/index.html). Using [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) for connected line and fancy icons.

> ![light theme screenshot](https://raw.githubusercontent.com/Moarram/zsh-theme/main/.github/images/zsh_theme_light.png)
> Status showing "+" for staged changes, "!" for unstaged changes, and "?" for untracked files (configurable).

> ![brown theme screenshot](https://raw.githubusercontent.com/Moarram/zsh-theme/main/.github/images/zsh_theme_brown.png)
> Optional icons, special font needed.

> ![dark theme screenshot](https://raw.githubusercontent.com/Moarram/zsh-theme/main/.github/images/zsh_theme_dark.png)
> Path truncated to fit in available space.


## Installation
### Dependencies
Requires ZSH (obviously), Git, and Python (for [Git status](https://github.com/olivierverdier/zsh-git-prompt) retrieval).

### Standard Install
Clone the repository.
```
git clone https://github.com/moarram/zsh-theme.git
```

In your `~/.zshrc`, source `moarram.zsh-theme` from the repository.
```
source your/path/to/moarram.zsh-theme
```

### [Antigen](https://github.com/zsh-users/antigen) Install
Add the following line before `antigen apply` in your `~/.zshrc`.
```
antigen bundle moarram/zsh-theme@main
```

### Other Installs
I haven't tested with other frameworks. If you have success with another install method, let me know so I can add it to the README.

If you don't want Git status info, you only need `moarram.zsh-theme`. But if you want Git status info, you need `deps/zsh-git-status.sh` and `deps/gitstatus.py` available to `moarram.zsh-theme`, which is why I recommend cloning the repository.


## Customization
Edit the `moarram.zsh-theme` file to customize colors, styles, and symbols. You could also define the variables in your `~/.zshrc`. 
<!-- Options are summarized here.

### Separator Line
`____________`

The separator line can be set to show always, never, or when it's not the first prompt of the window (default). You can also change the character used for the line (if you prefer space for example).

### Information Line
`user @ host: ...path | branch [status]`

Each part of the information line can be individually styled using [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (which are conveniently aliased in the theme file). 

### Git Status
`[+!?↓↑✘]`

As configured, the Git status info shows "+" for staged changes, "!" for unstaged changes, "?" for untracked files, "↓" for commits behind, "↑" for commits ahead, "✘" for conflicts, and nothing when the branch is clean. All these characters can be customized.

### Prompt
`$ `

As configured, the prompt shows "$" normally and "#" for root. This can be customized by changing `PROMPT` (if you prefer "%" for example). -->
