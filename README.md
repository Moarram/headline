# Headline
<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/slice.png" width="600"/>

A stylish Zsh theme with deliberate use of space. Single file. No dependencies. Highly customizable.

<br>


## Features
### Separator Line
The namesake of the prompt, a line above the information with matching colors. May be disabled with `HL_SEP_MODE=off` for a more compact prompt.

### Information Line
`<user> @ <host> (<venv>): <path> | <branch> [<status>]`

This line collapses to fit within the terminal width. Individually style each segment of the information line using [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (which are conveniently aliased in the theme file). You can customize nearly everything about the segments and even add your own.

### Git Status
A segment with symbols describing the status of the current Git repository.

| Symbol | Meaning          |
|--------|------------------|
| `+`    | Staged changes   |
| `!`    | Unstaged changes |
| `?`    | Untracked files  |
| `↓`    | Commits behind   |
| `↑`    | Commits ahead    |
| `↕`    | Commits diverged |
| `*`    | Stashed files    |
| `✘`    | Conflicts        |
| (none) | Clean branch     |

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

More details in **[Installation](docs/Installation.md)**

<br>


## Customization
<img src="https://raw.githubusercontent.com/moarram/headline/assets/images/configs.gif" width="600"/>

The `headline.zsh-theme` file describes variables ([around line 80](headline.zsh-theme#L80)) for customizing prompt behavior, colors, styles, symbols, etc. You can edit the theme file directly or set these variables in your `~/.zshrc` *after* sourcing the theme to override the defaults. There are plenty of options so play around and make it your own!

More details in **[Customization](docs/Customization.md)**

<br>


## Terminal Setup
For the continuous line above the prompt, use a font with ligatures such as [Fira Code](https://github.com/tonsky/FiraCode). Alternatively, use the "lower 1/8th block" character instead of underscores with `HL_SEP[_LINE]='▁'`.

If you want symbols, use a font that has them such as [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) and include your desired symbols in `HL_CONTENT_TEMPLATE`.

More details in **[Terminal Setup](docs/Terminal-Setup.md)**

<br>


## Screenshots
Screenshots of theme in [iTerm2](https://iterm2.com/index.html). Using [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode) for continuous line and fancy icons.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/theme-light.png" width="600"/>
>
> Status showing `+` for staged changes, `!` for unstaged changes, and `?` for untracked files.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/theme-beige.png" width="600"/>
>
> Optional icons, special font required.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/theme-brown.png" width="600"/>
>
> Path truncated to fit in available space, user and host hidden.

> <img src="https://raw.githubusercontent.com/moarram/headline/assets/images/theme-dark.png" width="600"/>
>
> Options to show clock (`HL_CLOCK_MODE=on`), show exit code with meaning (`HL_ERR_MODE=detail`), and hide identical information (`HL_INFO_MODE=auto`).

<br>


## Related
* [Headline Oh My Posh Theme](https://github.com/wathhr/headline-omp)

<br>


## Credits
* Headline's Git status functions are inspired by `git.zsh` in [Oh-My-Zsh's core library](https://github.com/ohmyzsh/ohmyzsh/blob/master/lib).
* Thanks to u/romkatv (author of [Powerlevel10k](https://github.com/romkatv/powerlevel10k)) for the [Reddit post](https://old.reddit.com/r/zsh/comments/cgbm24/multiline_prompt_the_missing_ingredient/) describing how to calculate prompt string display length.
