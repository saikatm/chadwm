# Requirements

- dash (shell)
- imlib2 
- xsetroot package (status2d uses this to add colors on dwmbar)
- JetbrainsMono Nerd Font or any nerd font but dont forget to set it in config.def.h
- Make sure to setup your terminal's theme accordingly do chadwm's theme such as nord, onedark etc...

## Other requirements
- picom
- feh
- acpi
- rofi

# Install

```
git clone https://github.com/siduck/chadwm --depth 1  ~/.config/chadwm
cd ~/.config/chadwm/
mv eww ~/.config
cd chadwm
sudo make install
press `Mod + Shift + r` to see changes without reboot.
```
(Note: chmod +x all of the scripts)

# Run chadwm

## With startx

```shell
startx ~/.config/chadwm/scripts/run.sh
```

## With sx

```shell
sx sh ~/.config/chadwm/scripts/run.sh
```

(Make an alias for this :v)

```shell
alias chadwm='startx ~/.config/chadwm/scripts/run.sh'
```

## With Display Manager

- Create a desktop entry (make sure to change `user` with your user):

```shell
sudo touch /usr/share/xsessions/chadwm.desktop  
```

```
[Desktop Entry]
Name=chadwm
Comment=dwm made beautiful 
Exec=/home/user_name/.config/chadwm/scripts/./run.sh 
Type=Application 
```
- Remeber to change the `user_name`


# Recompile

- You need to recompile dwm after every change you make to its source code.

```
cd ~/.config/chadwm/chadwm
make clean
sudo make install
```

# Change themes

- Bar  : in bar.sh (line 9) and config.def.h (line 35)
- eww  : in eww.scss (line 1)
- rofi : in config.rasi (line 15)

# Eww

- First, make sure you have copied the eww directory to your config:

```
cp -r ~/.config/chadwm/eww ~/.config/
```

- To launch the eww widget, you need the following command:

```
eww open eww
```
(Note: I use only alsa on my system so audio scripts on widget are alsa related, modify them to support pulseaudio)

- It could be a good idea to add these lines to your autostart file, located at ~/.config/chadwm/scripts/run.sh

# Credits

-  THANKS to [chadwm](https://github.com/siduck/chadwm). 

# Patches
- [systray](https://gitlab.com/-/snippets/2184056)
- systray iconsize
- barpadding 
- bottomstack
- cfacts
- dragmfact 
- dragcfact (took from [bakkeby's build](https://github.com/bakkeby/dwm-flexipatch))
- fibonacii
- gaplessgrid
- horizgrid
- movestack 
- vanity gaps
- colorful tags
- statuspadding 
- status2d
- underline tags
- notitle
- winicon
- [preserveonrestart](https://github.com/PhyTech-R0/dwm-phyOS/blob/master/patches/dwm-6.3-patches/dwm-preserveonrestart-6.3.diff). This patch doesnt let all windows mix up into tag 1 after restarting dwm.
- shiftview
