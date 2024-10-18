# Terminal Setup
The following features depend on terminal settings.

<br>


## Continuous Line
For the continuous separator line above the prompt, I recommend a font with ligatures (and a terminal that supports them). I know [Fira Code](https://github.com/tonsky/FiraCode) works well, but any font that joins adjacent underscores will do. You may need to enable font ligatures in your terminal settings.

If your terminal doesn't support ligatures, or you don't want a different font, consider using the "lower 1/8th block" character to build the separator line with `HL_SEP[_LINE]='▁'`. This character naturally fills the width of the cell so it doesn't require ligatures. Note that the resulting line is a bit thicker.

<br>


## Symbols
For symbols you could use a font patched with [Nerd Fonts](https://www.nerdfonts.com/), such as [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode). If the linked FiraCode Nerd Font doesn't work, you could try [patching it yourself](https://github.com/ryanoasis/nerd-fonts#font-patcher) (or any other font for that matter).

### Install FiraCode Nerd Font
1. Follow the link to [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FiraCode), navigate to the `ttf` file for the font size you want (such as `Regular > complete > Fira Code Regular Nerd Font Complete.ttf`, and download it (right click should have an option)
1. Add it to your system (probably by double clicking the font file)
1. Set it as the font for your terminal (depends on your terminal, might need to enable font ligatures)

### Specify Symbols
Add your symbols to the templates in `HL_CONTENT_TEMPLATE`. You can do this in your `~/.zshrc` after the theme has been sourced, or in the theme file itself. The symbols I used are in comments in the theme file, but you will only see them properly once your font is installed.

<br>


## Colors
The colors of the theme are customized with [ANSI SGR codes](https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_(Select_Graphic_Rendition)_parameters) (see [Customization](Customization.md)), but it's worth noting that your terminal ultimately decides the exact color each code represents. Also, the background and cursor colors are set by the terminal.

### iTerm2
The iTerm2 color schemes I use (featured in the screenshots) are available [here](https://github.com/Moarram/dotfiles/tree/main/itermcolors).

### Hex Values
If you just want the main colors for the 3 themes (dark, light, and brown), here they are:

|               | Dark      | Light     | Brown     |
|---------------|-----------|-----------|-----------|
| black         | `#212121` | `#252525` | `#432C1A` |
| red           | `#EE5656` | `#DB4F4F` | `#E34642` |
| green         | `#84D74B` | `#6FAE44` | `#909B00` |
| yellow        | `#EFC83D` | `#E49F26` | `#ECA915` |
| blue          | `#5EAFFF` | `#4C8FDD` | `#4698A3` |
| magenta       | `#EB6AB9` | `#CD58DC` | `#DA698D` |
| cyan          | `#5ED7AF` | `#17AA9B` | `#BA7C3E` |
| white         | `#CCCCCC` | `#E4E1DE` | `#DDC165` |
| light black   | `#535353` | `#9F9994` | `#896B4C` |
| light red     | `#FF7B7B` | `#ED7B7B` | `#E17662` |
| light green   | `#B7F178` | `#96D262` | `#BFC659` |
| light yellow  | `#FAEF59` | `#E8C138` | `#FFCA1B` |
| light blue    | `#89DFFF` | `#84B7EA` | `#7CC9CF` |
| light magenta | `#FFA3D5` | `#F271BF` | `#F492A6` |
| light cyan    | `#95FFE9` | `#63CBA8` | `#E6A96B` |
| light white   | `#F4F4F4` | `#F9F8F7` | `#FFEAA3` |
| background    | `#101010` | `#EFEEEC` | `#33200E` |
| foreground    | `#E3E3E3` | `#323232` | `#F2D886` |
| cursor        | `#E3E3E3` | `#8F8C88` | `#EC6F23` |
