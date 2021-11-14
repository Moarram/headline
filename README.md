# Headline ZSH Theme
<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/slice.png" width="600"/>

Headline. A stylish theme with thoughtful use of space. Requires no dependencies. Easily customizable.

<br>


## Contents
* [Features](#features)
* [Installation](#installation)
* [Customization](#customization)
* [Terminal Setup](#terminal-setup)
* [Screenshots](#screenshots)

<br>


## Features
### Separator Line
A line above the prompt info text with matching colors. Disable with `HEADLINE_LINE_MODE=off` for a more compact prompt.

### Information Line
`<user> @ <host>: <path> | <branch> [<status>]`

This line is responsive, meaning it won't overflow when it gets too long. Individually style each segment of the information line using [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (which are conveniently aliased in the theme file). You can customize the characters for joining segments and disable segments entirely.

### Git Status
All the Git status symbols are customizable. The defaults are below:

| Symbol | Meaning          |
|--------|------------------|
| `+`    | staged changes   |
| `!`    | unstaged changes |
| `?`    | untracked files  |
| `↓`    | commits behind   |
| `↑`    | commits ahead    |
| `↕`    | commits diverged |
| `*`    | stashed files    |
| `✘`    | conflicts        |
| (none) | clean branch     |

<br>


## Installation
Download the `headline.zsh-theme` file.
```
wget https://raw.githubusercontent.com/moarram/headline/main/headline.zsh-theme
```

In your `~/.zshrc`, source the `headline.zsh-theme` file.
```
source your/path/to/headline.zsh-theme
```

More details on the wiki page: [Installation](https://github.com/Moarram/headline/wiki/Installation)

<br>


## Customization
Set the variables, as described in `headline.zsh-theme`, in your `~/.zshrc` after the theme is sourced to customize behavior, colors, styles, symbols, etc. Play around with it and make it your own!

More details on the wiki page: [Customization](https://github.com/Moarram/headline/wiki/Customization)

<br>


## Terminal Setup
### Continuous Line
For the continuous separator line above the prompt you need a font with ligatures (and a terminal that supports them). I know [Fira Code](https://github.com/tonsky/FiraCode) works well, but any font that joins adjacent underscores will do.

### Symbols
For symbols you could use a font patched with [Nerd Fonts](https://www.nerdfonts.com/), such as [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode).

Specify your symbols of choice by assigning to the variables `HEADLINE_USER_PREFIX`, `HEADLINE_HOST_PREFIX`, `HEADLINE_PATH_PREFIX`, and `HEADLINE_BRANCH_PREFIX`.

### Colors
Although the colors of the theme are customized with [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters), your terminal ultimately decides the exact color each code represents. Also, the background and cursor colors are set by the terminal.

<br>


## Screenshots
Screenshots of theme in [iTerm2](https://iterm2.com/index.html). Using [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) for continuous line and fancy icons.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_light.png" width="600"/>
> 
> Status showing `+` for staged changes, `!` for unstaged changes, and `?` for untracked files (configurable).

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_brown.png" width="600"/>
> 
> Optional icons, special font needed.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_dark.png" width="600"/>
> 
> Path truncated to fit in available space, user and host hidden.

<br>