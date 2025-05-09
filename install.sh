#!/bin/sh

# SPDX-FileCopyrightText: 2025 Yuval Adar <adary@adary.org>
# SPDX-License-Identifier: MIT

# This script should run through curl:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/adaryorg/nocturne-dev/refs/heads/main/install.sh)"
#
set -e


# The following functions were mostly lifted from oh-my-zsh installer which is
# Copyright (c) 2009-2025 Robby Russell and contributors (https://github.com/ohmyzsh/ohmyzsh/contributors)
#
# Adapted for Nocturne installer by Yuval Adar (adary@adary.org)

# check for tty

if [ -t 1 ]; then
    is_tty() {
        true
    }
else
    is_tty() {
        false
    }
fi

supports_hyperlinks() {
    # $FORCE_HYPERLINK must be set and be non-zero (this acts as a logic bypass)
    if [ -n "$FORCE_HYPERLINK" ]; then
        [ "$FORCE_HYPERLINK" != 0 ]
        return $?
    fi

    # If stdout is not a tty, it doesn't support hyperlinks
    is_tty || return 1

    # DomTerm terminal emulator (domterm.org)
    if [ -n "$DOMTERM" ]; then
        return 0
    fi

    # VTE-based terminals above v0.50 (Gnome Terminal, Guake, ROXTerm, etc)
    if [ -n "$VTE_VERSION" ]; then
        [ $VTE_VERSION -ge 5000 ]
        return $?
    fi

    # If $TERM_PROGRAM is set, these terminals support hyperlinks
    # modified from original to add ghostty
    case "$TERM_PROGRAM" in
        Hyper|iTerm.app|terminology|WezTerm|ghostty|vscode) return 0 ;;
    esac

    # These termcap entries support hyperlinks
    case "$TERM" in
        xterm-kitty|alacritty|alacritty-direct) return 0 ;;
    esac

    # xfce4-terminal supports hyperlinks
    if [ "$COLORTERM" = "xfce4-terminal" ]; then
        return 0
    fi

    # Windows Terminal also supports hyperlinks
    if [ -n "$WT_SESSION" ]; then
        return 0
    fi

    return 1
}

supports_truecolor() {
    case "$COLORTERM" in
        truecolor | 24bit) return 0 ;;
    esac

    case "$TERM" in
        iterm | \
            tmux-truecolor | \
            linux-truecolor | \
            xterm-truecolor | \
            screen-truecolor) return 0 ;;
        esac

        return 1
    }

fmt_link() {
    # $1: text, $2: url, $3: fallback mode
    if supports_hyperlinks; then
        printf '\033]8;;%s\033\\%s\033]8;;\033\\\n' "$2" "$1"
        return
    fi

    case "$3" in
        --text) printf '%s\n' "$1" ;;
        --url | *) fmt_underline "$2" ;;
    esac
}

fmt_underline() {
    is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

# shellcheck disable=SC2016 # backtick in single-quote
fmt_code() {
    is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_warning() {
    printf '%s Warning: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}

fmt_error() {
    printf '%s Error: %s%s\n' "${FMT_BOLD}${FMT_RED}" "$*" "$FMT_RESET" >&2
}

fmt_info() {
    printf '%s Info: %s%s\n' "${FMT_BOLD}${FMT_BLUE}" "$*" "$FMT_RESET" >&2
}

setup_color() {
    # Only use colors if connected to a terminal
    if ! is_tty; then
        FMT_RAINBOW=""
        FMT_RED=""
        FMT_GREEN=""
        FMT_YELLOW=""
        FMT_BLUE=""
        FMT_BOLD=""
        FMT_RESET=""
        return
    fi

    if supports_truecolor; then
        FMT_RAINBOW="
        $(printf '\033[38;2;255;0;0m')
        $(printf '\033[38;2;255;97;0m')
        $(printf '\033[38;2;247;255;0m')
        $(printf '\033[38;2;0;255;30m')
        $(printf '\033[38;2;77;0;255m')
        $(printf '\033[38;2;168;0;255m')
        $(printf '\033[38;2;245;0;172m')
        $(printf '\033[38;2;51;255;249m')
        "
    else
        FMT_RAINBOW="
        $(printf '\033[38;5;196m')
        $(printf '\033[38;5;202m')
        $(printf '\033[38;5;226m')
        $(printf '\033[38;5;082m')
        $(printf '\033[38;5;021m')
        $(printf '\033[38;5;093m')
        $(printf '\033[38;5;163m')
        $(printf '\033[38;5;051m')
        "
    fi

    FMT_RED=$(printf '\033[31m')
    FMT_GREEN=$(printf '\033[32m')
    FMT_YELLOW=$(printf '\033[33m')
    FMT_BLUE=$(printf '\033[34m')
    FMT_BOLD=$(printf '\033[1m')
    FMT_RESET=$(printf '\033[0m')
}

print_header() {
    if ! supports_truecolor; then
        printf 'Welcome to\n'
        printf '\n'
        printf '%s███    ██%s  ██████  %s ██████ %s████████ %s██    ██ %s██████  %s███    ██ %s███████%s\n' $FMT_RAINBOW $FMT_RESET
        printf '%s████   ██%s ██    ██ %s██      %s   ██    %s██    ██ %s██   ██ %s████   ██ %s██     %s\n' $FMT_RAINBOW $FMT_RESET
        printf '%s██ ██  ██%s ██    ██ %s██      %s   ██    %s██    ██ %s██████  %s██ ██  ██ %s█████  %s\n' $FMT_RAINBOW $FMT_RESET
        printf '%s██  ██ ██%s ██    ██ %s██      %s   ██    %s██    ██ %s██   ██ %s██  ██ ██ %s██     %s\n' $FMT_RAINBOW $FMT_RESET
        printf '%s██   ████%s  ██████  %s ██████ %s   ██    %s ██████  %s██   ██ %s██   ████ %s███████%s\n' $FMT_RAINBOW $FMT_RESET
        printf '\n'
        printf 'Buckle up and enjoy the ride!\n'
    else
        echo "
        Welcome to

        ███    ██  ██████   ██████ ████████ ██    ██ ██████  ███    ██ ███████
        ████   ██ ██    ██ ██         ██    ██    ██ ██   ██ ████   ██ ██
        ██ ██  ██ ██    ██ ██         ██    ██    ██ ██████  ██ ██  ██ █████
        ██  ██ ██ ██    ██ ██         ██    ██    ██ ██   ██ ██  ██ ██ ██
        ██   ████  ██████   ██████    ██     ██████  ██   ██ ██   ████ ███████

        Buckle up and enjoy the ride!
        " | lolcat #lolcat is much more fun than static rainbow colors!
    fi
}

# kinda important to detect the platform and make sure bare necessities are present
# this information will be passed on to the rest of install scripts
install_gum_ubuntu() {
    cd /tmp
    GUM_VERSION="0.16.0" # Use known good version
    wget -qO gum.deb "https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/gum_${GUM_VERSION}_amd64.deb"
    sudo apt-get install -y ./gum.deb
    rm gum.deb
    cd -    
}
detectPlatform() {
    if [ ! -f /etc/os-release ]
    then
        fmt_error "Non Linux (or weird Linux) support not added yet. Please wait for a future release."
        exit 0
    fi
    . /etc/os-release
    case $ID in
        "arch")
            INSTALLER="pacman"
            # install git and less
            fmt_info "Detected Arch based system. Installing basic prerequisites."
            sudo pacman -Sy --noconfirm gum git less unzip lolcat >> $NOCTURNE_LOG/pre-bootstrap.log 2>&1 
            ;;
        "fedora")
            echo "Fedora detected"
            if [ $(echo "$VERSION_ID > 41" | bc) != 1 ]; then
                fmt_error "Fedora versions older than 42 are not supported!"
                exit 1
            fi
            fmt_info "Detected rpm based system. Installing basic prerequisites."
            sudo dnf install -y gum git less unzip lolcat >> $NOCTURNE_LOG/pre-bootstrap.log 2>&1 
            INSTALLER="dnf"
            ;;
        "ubuntu")
            if [ $(echo "$VERSION_ID >= 24.04" | bc) != 1 ]; then
                fmt_error "Ubuntu versions older than 24.04 are not supported!"
                exit 1
            fi
            fmt_info "Detected deb based system.  Installing basic prerequisites."
            sudo apt install -y git less unzip lolcat >> $NOCTURNE_LOG/pre-bootstrap.log 2>&1 
            if [ $(echo "$VERSION_ID > 24.04" |bc) != 1  ]; then
                install_gum_ubuntu >> $NOCTURNE_LOG/pre-bootstrap.log 2>&1
            else
                sudo apt -y install gum >> $NOCTURNE_LOG/pre-bootstrap.log 2>&1 
            fi
            INSTALLER="apt"
            ;;
        *)
            fmt_error "Unknown Linux distro detected. Support might be added in the future!"
            exit 0
            ;;
    esac
}

# start the main logic
ostype=$(uname)
USER=${USER:-$(id -u -n)}
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
HOME="${HOME:-$(eval echo ~$USER)}"
NOCTURNE=${NOCTURNE:-"$HOME/.local/share/nocturne"}
NOCTURNE_GIT=${NOCTURNE_GIT:-"$HOME/.nocturne"}
NOCTURNE_DOT=${NOCTURNE_DOT:-"$HOME/.nocturne_dotfiles"}
NOCTURNE_LOG=${NOCTURNE_LOG:-"$NOCTURNE/log"}
if [ ! -d $NOCTURNE_LOG ]
then
    mkdir -p $NOCTURNE_LOG
fi

setup_color
detectPlatform
print_header

if [ -d $NOCTURNE_GIT ]
then
    fmt_warning "Old version of Nocturne detected at $NOCTURNE_GIT"
    fmt_warning "Proceeding with installation will delete this folder!"
fi

fmt_info "Press x to exit or any other key to continue."
read -r input

if [ "$input" = "x" ]; then
    exit 0
else
    if [ -d $NOCTURNE_GIT ]; then
        # lets get rid of the old version if it's there
        fmt_warning "Deleting $NOCTURNE_GIT"
        rm -rf ~/.nocturne
    fi
    fmt_info "Fetching Nocturne installer."
    git clone https://github.com/adaryorg/nocturne-dev.git $NOCTURNE_GIT >/dev/null 2>&1
fi

# show the disclaimer!
${PAGER:-less} $NOCTURNE_GIT/disclaimer

fmt_info "Having read everything from the previously displayed text, are you sure you want to proceed?"
fmt_info "This is not the last chance to bail about but still think about it!"
select yn in "Yes" "No"; do
    case $yn in
        Yes) break ;;
        No) exit ;;
    esac
done

case $INSTALLER in
    "apt")
        source ~/.nocturne/bootstrap/bootstrap-ubuntu.sh
        ;;
    "dnf")
        source ~/.nocturne/bootstrap/bootstrap-fedora.sh
        ;;
    "pacman")
        source ~/.nocturne/bootstrap/bootstrap-arch.sh
        ;;
esac
