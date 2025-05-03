#!/bin/sh
set -e

# This script should run through curl:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/adaryorg/nocturne-dev/refs/heads/main/install.sh)"

detectPlatform() {
    if [ ! -f /etc/os-release ]
    then
        echo "Non Linux (or weird Linux) support not added yet. Please wait for a future release."
        exit 0
    fi
    . /etc/os-release
    case $ID in
        "arch")
            INSTALLER="pacman"
            # install git and less
            echo "Detected Arch Linux. Installing git and less"
            sudo pacman -Sy --noconfirm git less
            ;;
        "fedora")
            INSTALLER="dnf"
            ;;
        "ubuntu")
            INSTALLER="apt"
            ;;
    esac
}

essentialsMissing() {
    /usr/bin/cat <<EOF
Essential software not detected on your host (git and less)

To install essentials on Ubuntu: sudo apt install git less
To install essentials on Fedora: sudo dnf install git less
To install essentials on Arch: sudo pacman -Sy git less
EOF
    exit 1
}

detectPlatform

if [ ! -f /usr/bin/git ]; then
    essentialsMissing
elif [ ! -f /usr/bin/less ]; then
    essentialsMissing
else
    echo "Welcome to Nocturne installer."
    echo "This script will remove any old version(s) of Nocturne if present"
    echo "If the folder ~/.nocturne exists it will be deleted!"
    echo "If you care for this system at all, make sure to back it up before proceeding."
    echo "Press x to exit or any other key to continue." mainmenuinput
    read -r mainmenuinput
    if [ "$mainmenuinput" = "x" ]; then
        exit 0
    else
        if [ -d ~/.nocturne ]; then
            # lets get rid of the old version if it's there
            echo "Deleting ~/.nocturne"
            rm -rf ~/.nocturne
        fi
        echo "Fetching Nocturne installer."
        git clone https://github.com/adaryorg/nocturne-dev.git ~/.nocturne >/dev/null 2>&1
    fi
fi
${PAGER:-less} ~/.nocturne/disclaimer
#clear
echo "Having read everything from the previously displayed text, are you sure you want to proceed?"
select yn in "Yes" "No"; do
    case $yn in
    Yes) break ;;
    No) exit ;;
    esac
done
source ~/.nocturne/bootstrap/check-version.sh
