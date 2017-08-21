#
# ~/.xinitrc
#

# Disable mouse acceleration
xset m 0 0

# Set wallpaper
feh --bg-scale $HOME/Pictures/wallpaper

# Set keyboard layout
setxkbmap de,de

# Remap Capslock to escape
setxkbmap -option caps:escape


# Start caffeine (systray) in background
caffeine &

# Run i3wm
exec i3
