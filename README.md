# Headline ZSH Theme
<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/slice.png" width="600"/>

<br/>


## Contents
* [Features](#features)
* [Screenshots](#screenshots)
* [Installation](#installation)
	* [Standard Install](#standard-install)
	* [Oh-My-Zsh](#oh-my-zsh-install)
	* [Antigen](#antigen-install)
	* [Other Installs](#other-installs)
* [Customization](#customization)

<br/>


## Features
### Separator Line
`_____________________________________________`

A line above the prompt info text with matching colors. It can be disabled by setting `HEADLINE_LINE_MODE=off`.

### Information Line
`<user> @ <host>: <path> | <branch> [<status>]`

This line is responsive, meaning it won't overflow when it gets too long. Each part of the information line can be individually styled using [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (which are conveniently aliased in the theme file).

### Git Status
`[+!?↓↑↕*✘]`

All the Git status symbols can be customized. The defaults are below:

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

### Prompt
The prompt shows `$` normally and `#` for root. This can be changed to `%` and `#` by setting `HEADLINE_PROMPT="%#"`.

<br/>


## Screenshots
Screenshots of theme in [iTerm2](https://iterm2.com/index.html). Using [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) for connected line and fancy icons.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_light.png" width="600"/>
> 
> Status showing `+` for staged changes, `!` for unstaged changes, and `?` for untracked files (configurable).

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_brown.png" width="600"/>
> 
> Optional icons, special font needed.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/zsh_theme_dark.png" width="600"/>
> 
> Path truncated to fit in available space.

<br/>


## Installation
Download the `headline.zsh-theme` file and source it in your `~/.zshrc`.

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

Set the theme in your `~/.zshrc` with `ZSH_THEME="headline"` (or with `ZSH_THEME="headline/headline"` if you didn't symlink).

### [Antigen](https://github.com/zsh-users/antigen) Install
Add the following line to your `~/.zshrc`.
```
antigen bundle moarram/headline@main
```

### Other Installs
I haven't tested with other frameworks. If you have success with another install method, let me know so I can add it to the README.

<br/>


## Customization
Set the variables, as described in `headline.zsh-theme`, in your `~/.zshrc` after the theme is sourced to customize colors, styles, and symbols.
