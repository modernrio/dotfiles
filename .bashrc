#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Set console to use vi mode
set -o vi

# Set keyboard map to german layout
setxkbmap de,de

# Activate numlock
numlockx on

# Suppress python byte code
export PYTHONDONTWRITEBYTECODE="true"

#------------------------------------------------------------------------------#
#                              Default Variables                               #
#------------------------------------------------------------------------------#
export EDITOR="nvim"
export PAGER="less"
export BROWSER="firefox"
export MAIL="mutt"
export MOVPLAY="mpv"
export PICVIEW="feh"
export SNDPLAY="mpv"
export DOCVIEWER="zathura"
export TERMINAL="uxterm"
export PULSE_LATENCY_MSEC=60
export TERM="xterm-256color"
export ETH_IF="eno1"

#------------------------------------------------------------------------------#
#                                   Aliases                                    #
#------------------------------------------------------------------------------#
# Source aliases from file
source ~/.aliases
