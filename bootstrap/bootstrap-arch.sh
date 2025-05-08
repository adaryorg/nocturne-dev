#little env prep
export PATH="$PATH:$HOME/.local/bin"

# bare essentials
fmt_info "Installing essentials. Full installation log will be avaiable at:"
fmt_link "$NOCTURNE_LOG/bootstrap.log"
sudo pacman -Sy --noconfirm curl git less base-devel wget zsh python3 tmux htop btop vim nvim tree fzf jq zip unzip stow >$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!

# install yay
if [ ! -d $NOCTURNE/tmp ]; then
    mkdir -p $NOCTURNE/tmp
fi

if [ -d $NOCTURNE/tmp/yay ]; then rm -rf $NOCTURNE/tmp/yay; fi

git clone https://aur.archlinux.org/yay-bin.git $NOCTURNE/tmp/yay >>$NOCTURNE_LOG/bootstrap.log 2>&1
cd $NOCTURNE/tmp/yay
makepkg -si --noconfirm >>$NOCTURNE_LOG/bootstrap.log 2>&1

cd -
# clean up
rm -rf $NOCTURNE/tmp/yay

# install all shell tools
fmt_info "Installing shell tools"
sudo pacman -Sy --noconfirm fastfetch github-cli lazygit zellij fzf ripgrep bat eza zoxide plocate btop tldr fd starship atuin thefuck >>$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!

fmt_info "Installing stuff(tm)"
sudo pacman -Sy --noconfirm autoconf bison clang rust openssl readline libyaml readline zlib ncurses libffi gdbm jemalloc imagemagick mupdf mupdf-tools sqlite mise gnupg gum >>$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!

fmt_info "Installing the best tool in the world (get ready to enter password)"
yay -Sy --noconfirm lazydocker >>$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!

# this will make me unpopular but we really do want all of gnome installed!
fmt_info "Installing GNOME packages ..."
sudo pacman -Sy --noconfirm gnome >>$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!

# install nerd fonts
fmt_info "Installing nerd fonts for all ya nerds out there!"
sudo pacman -Sy --noconfirm ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-cascadia-mono-nerd ttf-meslo-nerd >>$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!

# some gnome stuff from AUR
fmt_info "Installing more GNOME stuffs (it might ask for password again...)"
yay -Sy --noconfirm extension-manager python-pipx >>$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!
pipx install gnome-extensions-cli --system-site-packages >>$NOCTURNE_LOG/bootstrap.log 2>&1
spinner $!

source ~/.nocturne/bootstrap/bootstrap-common.sh
