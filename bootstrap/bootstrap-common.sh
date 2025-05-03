clear

# installing oh-my-zsh
if [[ -d ~/.oh-my-zsh ]]; then
    echo "oh-my-zsh already installed."
else
    echo "Installing oh-my-zsh and setting zsh as default shell."
    echo "Carefully read the instructions presented on screen and do everything"
    echo "oh-my-zsh installer asks you to do!"
    echo "press any key to continue"
    read -r input
    RUNZSH="no"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

#installing nocturne dotfiles
