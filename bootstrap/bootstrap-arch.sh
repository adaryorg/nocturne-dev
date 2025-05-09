#!/bin/sh

# this script is meant to be called from the main install script. running in alone will
# result in an epic failure. Consider yourself advised

# SPDX-FileCopyrightText: 2025 Yuval Adar <adary@adary.org>
# SPDX-License-Identifier: MIT

export PATH="$PATH:$HOME/.local/bin"

# bare essentials
gum spin --title="Installing base packages..." -- sudo pacman -Sy --noconfirm curl git less base-devel wget zsh python3 tmux htop btop vim nvim tree fzf jq zip unzip stow

# install yay
if [ ! -d $NOCTURNE/tmp ]; then
    mkdir -p $NOCTURNE/tmp
fi

if [ -d $NOCTURNE/tmp/yay ]; then rm -rf $NOCTURNE/tmp/yay; fi

git clone https://aur.archlinux.org/yay-bin.git $NOCTURNE/tmp/yay >>/dev/null 2>&1
cd $NOCTURNE/tmp/yay
gum spin --title="Installing yay..." -- makepkg -si --noconfirm

cd - >>/dev/null 2>&1
# clean up
rm -rf $NOCTURNE/tmp/yay

# install all shell tools
gum spin --title="Installing shell tools..." -- sudo pacman -Sy --noconfirm fastfetch github-cli lazygit zellij fzf ripgrep bat eza zoxide plocate btop tldr fd starship atuin thefuck
gum spin --title="Installing stuff(tm)..." -- sudo pacman -Sy --noconfirm autoconf bison clang rust openssl readline libyaml readline zlib ncurses libffi gdbm jemalloc imagemagick mupdf mupdf-tools sqlite mise gnupg gum
gum spin --title="Installing lazydocker (you know you need it!)..." -- yay -Sy --noconfirm lazydocker

# install nerd fonts
gum spin --title="Installing nerd fonts..." -- sudo pacman -Sy --noconfirm ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-cascadia-mono-nerd ttf-meslo-nerd

# this will make me unpopular but we really do want all of gnome installed!
gum spin --title="Installing GNOME packages..." -- sudo pacman -Sy --noconfirm gnome
gum spin --title="Instaling more GNOME stuff" -- yay -Sy --noconfirm extension-manager python-pipx
gum spin --title="Installing yet more GNOME stuff" -- pipx install gnome-extensions-cli --system-site-packages

source ~/.nocturne/bootstrap/bootstrap-common.sh
