#!/bin/sh

# this script is meant to be called from the main install script. running in alone will
# result in an epic failure. Consider yourself advised

# SPDX-FileCopyrightText: 2025 Yuval Adar <adary@adary.org>
# SPDX-License-Identifier: MIT

export PATH="$PATH:$HOME/.local/bin"

# bare essentials
fmt_info "Installing essentials. Full installation log will be avaiable at:"
fmt_link "$NOCTURNE_LOG/bootstrap.log"
gum spin --show-output --title="Installing base packages..." -- sudo pacman -Sy --noconfirm curl git less base-devel wget zsh python3 tmux htop btop vim nvim tree fzf jq zip unzip stow >>$NOCTURNE_LOG/bootstrap.log

# install yay
if [ ! -d $NOCTURNE/tmp ]; then
    mkdir -p $NOCTURNE/tmp
fi

if [ -d $NOCTURNE/tmp/yay ]; then rm -rf $NOCTURNE/tmp/yay; fi

git clone https://aur.archlinux.org/yay-bin.git $NOCTURNE/tmp/yay >>$NOCTURNE_LOG/bootstrap.log
cd $NOCTURNE/tmp/yay
gum spin --show-output --title="Installing yay..." -- makepkg -si --noconfirm >>$NOCTURNE_LOG/bootstrap.log 2>&1

cd - >>$NOCTURNE_LOG/bootstrap.log 2>&1
# clean up
rm -rf $NOCTURNE/tmp/yay

# install all shell tools
gum spin --show-output --title="Installing shell tools..." -- sudo pacman -Sy --noconfirm fastfetch github-cli lazygit zellij fzf ripgrep bat eza zoxide plocate btop tldr fd starship atuin thefuck >>$NOCTURNE_LOG/bootstrap.log
gum spin --show-output --title="Installing stuff(tm)..." -- sudo pacman -Sy --noconfirm autoconf bison clang rust openssl readline libyaml readline zlib ncurses libffi gdbm jemalloc imagemagick mupdf mupdf-tools sqlite mise gnupg gum >>$NOCTURNE_LOG/bootstrap.log
gum spin --show-output --title="Installing lazydocker (you know you need it!)..." -- yay -Sy --noconfirm lazydocker >>$NOCTURNE_LOG/bootstrap.log

# install nerd fonts
gum spin --show-output --info="Installing nerd fonts..." -- sudo pacman -Sy --noconfirm ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-cascadia-mono-nerd ttf-meslo-nerd >>$NOCTURNE_LOG/bootstrap.log

# this will make me unpopular but we really do want all of gnome installed!
gum spin --show-output --title="Installing GNOME packages..." -- sudo pacman -Sy --noconfirm gnome >>$NOCTURNE_LOG/bootstrap.log
gum spin --show-output --info="Instaling more GNOME stuff" -- yay -Sy --noconfirm extension-manager python-pipx i >>$NOCTURNE_LOG/bootstrap.log
gum spin --show-output --info="Installing yet more GNOME stuff" -- pipx install gnome-extensions-cli --system-site-packages >>$NOCTURNE_LOG/bootstrap.log

source ~/.nocturne/bootstrap/bootstrap-common.sh
