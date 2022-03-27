# Minimal Rice

My daily used programs are a few:

|        TYPE:       |  Program  |
| ----               | ----      |
| Window Manager     | `i3-gaps` |
| Compositor         | `Picom`   |
| Terminal           | `urxvt`   |
| Multiplixer        | `Tmux`    |
| Text Editor        | `Vim`     |
| CLI Browser (MAIN) | `Lynx`    |
| GUI Browser        | `Vimb`    |
| Colorscheme        | `pywal`   |

## Install Everything
You can install the whole rice: 
+ This installs all needed packages via
  - `pacman`
  - `pip3`

And symlinks my configs:
`.config`, `.local`, `etc`

**NOTE: This will overwrite any existing file in the same path.**

Run This command to install everything:
```bash
make all
```
## Set-up The Symlinks
If you want to only install the symlinks, you can run:

**NOTE: This will overwrite any existing file in the same path.**

```bash
make init
```

## Help
You can always see all available options by running
```bash
make
```
or
```bash
make help
```
