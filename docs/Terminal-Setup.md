# Terminal Setup
The following features depend on terminal settings.

<br>


## Continuous Line
For the continuous separator line above the prompt you need a font with ligatures (and a terminal that supports them). I know [Fira Code](https://github.com/tonsky/FiraCode) works well, but any font that joins adjacent underscores will do. You may need to enable font ligatures in your terminal settings.

<br>


## Symbols
For symbols you could use a font patched with [Nerd Fonts](https://www.nerdfonts.com/), such as [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode). If the linked FiraCode Nerd Font doesn't work, you could try [patching it yourself](https://github.com/ryanoasis/nerd-fonts#font-patcher) (or any other font for that matter).

### Install FiraCode Nerd Font
1. Follow the link to [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode), navigate to the `ttf` file for the font size you want (such as `Regular > complete > Fira Code Regular Nerd Font Complete.ttf`, and download it (right click should have an option)
1. Add it to your system (probably by double clicking the font file)
1. Set it as the font for your terminal (depends on your terminal, might need to enable font ligatures)

### Specify Symbols
Choose your symbols by assigning to the variables `HEADLINE_USER_PREFIX`, `HEADLINE_HOST_PREFIX`, `HEADLINE_PATH_PREFIX`, and `HEADLINE_BRANCH_PREFIX`. You can do this in your `~/.zshrc` after the theme has been sourced, or in the theme file itself. The symbols I used are in comments in the theme file, but you will only see them properly once your font is installed.

<br>


## Colors
The colors of the theme are customized with [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (see [Customization](Customization.md)), but it's worth noting that your terminal ultimately decides the exact color each code represents. Also, the background and cursor colors are set by the terminal.

### iTerm2
The iTerm2 color schemes I use (featured in the screenshots) are available [here](https://github.com/Moarram/dotfiles/tree/main/itermcolors).

<br>
