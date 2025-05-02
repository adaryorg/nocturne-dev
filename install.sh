#!/usr/bin/env bash

if [ ! -f $(command -v git) ]; then
    /usr/bin/cat <<EOF
$(tput setaf 1)git not detected on your host. 

To install git on Ubuntu: sudo apt install git
To install git on Fedora: sudo dnf install git
To install git on Arch: sudo pacman -Sy git 
EOF
    exit 1
else
    echo "Welcome to Nocturne installer."
    echo "This script will remove any old version(s) of Nocturne if present"
    echo "and will attempt to install the current version. If the folder ~/.nocturne"
    echo "exists it will be deleted!"
    echo "If you care for this system at all, make sure to back it up before proceeding."
    read -n 1 -p "Press x to exit or any other key to continue." mainmenuinput
    if [ "$mainmenuinput" = "x" ]; then
        exit 0
    else
        echo "BUREK"
        if [ -d ~/.nocturne ]; then
            # lets get rid of the old version if it's there
            echo "Deleting ~/.nocturne"
            rm -rf ~/.nocturne
        fi
        echo "BUREK2"
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
