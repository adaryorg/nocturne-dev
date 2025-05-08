clear

# installing oh-my-zsh
if [[ -d ~/.oh-my-zsh ]]; then
    fmt_info "oh-my-zsh already installed."
else
    fmt_info "Installing oh-my-zsh and setting zsh as default shell."
    fmt_info "Carefully read the instructions presented on screen and do everything"
    fmt_info "oh-my-zsh installer asks you to do!"
    fmt_info "press any key to continue"
    read -r input
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended >>$NOCTURNE_LOG/bootstrap.log 2>&1 &
    spinner $!
    sudo -k chsh -s /usr/bin/zsh "$USER"
fi

#installing nocturne dotfiles
