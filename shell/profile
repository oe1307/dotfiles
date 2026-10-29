#!/bin/bash

[ -z "$PS1" ] && return

if [ -f "${HOME}/.homebrew/bin/zsh" ]; then
    ZSH="${HOME}/.homebrew/bin/zsh"
    [ -x "${ZSH}" ] && SHELL="${ZSH}" exec "${ZSH}" -l
    return

elif [ -f "/usr/bin/zsh" ]; then
    ZSH="/usr/bin/zsh"
    [ -x "${ZSH}" ] && SHELL="${ZSH}" exec "${ZSH}" -l
    return
else
    echo "zsh not found"
fi
