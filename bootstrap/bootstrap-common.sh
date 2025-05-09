#!/bin/sh

# this script is meant to be called from the main install script. running in alone will
# result in an epic failure. Consider yourself advised

# SPDX-FileCopyrightText: 2025 Yuval Adar <adary@adary.org>
# SPDX-License-Identifier: MIT

# installing oh-my-zsh
if [[ -d ~/.oh-my-zsh ]]; then
    fmt_info "oh-my-zsh already installed."
else
    fmt_info "Installing oh-my-zsh and setting zsh as default shell."
    gum spin --title="Installing oh-my-zsh..." -- sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >>$NOCTURNE_LOG/bootstrap.log 2>&1
    sudo -k chsh -s /usr/bin/zsh "$USER"
fi

#installing nocturne dotfiles
