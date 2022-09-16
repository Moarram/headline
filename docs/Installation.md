# Installation
To install Headline, download the `headline.zsh-theme` file and source it in your `~/.zshrc`. To see your changes open a new shell (or re-source with `. ~/.zshrc`).

<br>


## Standard
Clone the repository.
```
$ git clone https://github.com/moarram/headline.git
```

In your `~/.zshrc`, source the `headline.zsh-theme` file in the repository.
```
source your/path/to/headline.zsh-theme
```

<br>


## Minimal
Instead of cloning the whole repository, only download the theme file.
```
$ wget https://raw.githubusercontent.com/moarram/headline/main/headline.zsh-theme
```

Source the theme as before.

<br>


## [Oh-My-Zsh](https://github.com/ohmyzsh/ohmyzsh)
Clone the repository into your themes directory.
```
$ git clone https://github.com/moarram/headline.git $ZSH_CUSTOM/themes/headline
```

Create a symlink to the theme (optional).
```
$ ln -s $ZSH_CUSTOM/themes/headline/headline.zsh-theme $ZSH_CUSTOM/themes/headline.zsh-theme
```

Set the theme in your `~/.zshrc` with `ZSH_THEME="headline"` (or with `ZSH_THEME="headline/headline"` if you didn't symlink).

<br>


## [Antigen](https://github.com/zsh-users/antigen)
Add the following line to your `~/.zshrc`.
```
antigen bundle moarram/headline@main
```

<br>
