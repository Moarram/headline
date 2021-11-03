# Headline ZSH Theme
A responsive ZSH theme featuring Git status information and a colored line above the prompt.


## Screenshots
Screenshots of theme in [iTerm2](https://iterm2.com/index.html). Using [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) for connected line and fancy icons.

> ![light theme screenshot](https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_light.png)
> Status showing `+` for staged changes, `!` for unstaged changes, and `?` for untracked files (configurable).

> ![brown theme screenshot](https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_brown.png)
> Optional icons, special font needed.

> ![dark theme screenshot](https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_dark.png)
> Path truncated to fit in available space.


## Installation
### Dependencies
* [ZSH](https://zsh.sourceforge.io/) – required
* [Git](https://git-scm.com/) – for installation (optional)
* [Python 3](https://www.python.org/) – for [Git status](https://github.com/olivierverdier/zsh-git-prompt) retrieval (optional)

### Standard Install
Clone the repository.
```
git clone https://github.com/moarram/headline.git
```

In your `~/.zshrc`, source the `headline.zsh-theme` file in the repository.
```
source your/path/to/headline.zsh-theme
```

### [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh) Install
Clone the repository into your themes directory.
```
git clone https://github.com/moarram/headline.git $ZSH_CUSTOM/themes/headline
```

Create a symlink to the theme (optional).
```
ln -s $ZSH_CUSTOM/themes/headline/headline.zsh-theme $ZSH_CUSTOM/themes/headline.zsh-theme
```

Set the theme in your `~/.zshrc` with `ZSH_THEME="headline"`, or with `ZSH_THEME="headline/headline"` if you didn't symlink.

### [Antigen](https://github.com/zsh-users/antigen) Install
Add the following line to your `~/.zshrc`.
```
antigen bundle moarram/headline@main
```

### Minimal Install
*No Python, only shows branch for Git*

Download the `headline.zsh-theme` file alone and source it in your `~/.zshrc`. The prompt won't show all the Git information, only the branch, but it's faster and contained in a single file.

### Other Installs
I haven't tested with other frameworks. If you have success with another install method, let me know so I can add it to the README.


## Features
### Separator Line
```_____________________________________________```

A line above the prompt info text with matching colors. It can be disabled if you want.

### Information Line
```<user> @ <host>: <path> | <branch> [<status>]```

Shows the user, host, path, git branch, and git status. This line is responsive, meaning it won't overflow when it gets too long. Each part of the information line can be individually styled using [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (which are conveniently aliased in the theme file).

### Git Status
```[+!?↓↑✘]```

By default, the Git status info shows `+` for staged changes, `!` for unstaged changes, `?` for untracked files, `↓` for commits behind, `↑` for commits ahead, `✘` for conflicts, and nothing when the branch is clean. All these characters can be customized.

### Prompt
```$```

The prompt shows `$` normally and `#` for root. This can be customized by setting `PROMPT`. 


## Customization
Set the variables, as described in `headline.zsh-theme`, in your `~/.zshrc` after the theme is sourced to customize colors, styles, and symbols.
