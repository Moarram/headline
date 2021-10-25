# Moarram's ZSH Theme
A ZSH theme featuring Git status information and a colored line before the prompt.

```
________________________________________________________________________________
<user> @ <machine>: <path>                                   <branch> [<status>]
$
```

## Screenshots
Screenshots of theme in iTerm2. Using the FiraCode font for connected underscores.

>![light theme screenshot](https://raw.githubusercontent.com/Moarram/zsh-theme/main/.github/images/zsh_theme_light.png)
>Status shows "+" for staged changes, "!" for unstaged changes, and "?" for untracked files (configurable).

> ![brown theme screenshot](https://raw.githubusercontent.com/Moarram/zsh-theme/main/.github/images/zsh_theme_brown.png)
> Optional contextual symbols.

> ![dark theme screenshot](https://raw.githubusercontent.com/Moarram/zsh-theme/main/.github/images/zsh_theme_dark.png)
> Path truncated to fit in available space.


## Installation
### Dependencies
Requires ZSH (obviously), Git, and Python (for [Git status](https://github.com/olivierverdier/zsh-git-prompt) retrieval).

### Download
Clone the repository.

```
git clone https://github.com/Moarram/zsh-theme.git
```

### Setup
In your `~/.zshrc`, source the `moarram.zsh-theme` file.

```
source your/path/to/moarram.zsh-theme
```
