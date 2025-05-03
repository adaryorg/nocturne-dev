#!/bin/sh
set -e

# This script should run through curl:
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/adaryorg/nocturne-dev/refs/heads/main/install.sh)"

ostype=$(uname)

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
            echo "Detected Arch based system. If requested, enter your password to install git and less."
            sudo pacman -Sy --noconfirm git less unzip
            ;;
        "fedora")
            echo "Fedora detected"
            if [ $(echo "$VERSION_ID >= 41" | bc) != 1 ]; then
                echo "Fedora versions older than 41 are not supported!"
                exit 1
            fi
            echo "Detected rpm based system. If requested, enter your password to install git and less."
            sudo dnf install -y git less unzip
            INSTALLER="dnf"
            ;;
        "ubuntu")
            if [ $(echo "$VERSION_ID >= 24.04" | bc) != 1 ]; then
                echo "Ubuntu versions older than 24.04 are not supported!"
                exit 1
            fi
            echo "Detected deb based system. If requested, enter your password to install git and less."
            sudo apt install -y git less unzip
            INSTALLER="apt"
            ;;
        *)
            echo "Unknown Linux distro detected. Support might be added in the future!"
            exit 0
            ;;
    esac
}

detectPlatform

echo "Welcome to Nocturne installer."
echo "This script will remove any old version(s) of Nocturne if present"
echo "If the folder ~/.nocturne exists it will be deleted!"
echo "If you care for this system at all, make sure to back it up before proceeding."
echo ""
echo "Press x to exit or any other key to continue." 
read -r input

if [ "$input" = "x" ]; then
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

# show the disclaimer!
${PAGER:-less} ~/.nocturne/disclaimer

echo "Having read everything from the previously displayed text, are you sure you want to proceed?"
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
