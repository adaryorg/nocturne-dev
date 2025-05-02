# bare essentials
sudo pacman -Sy --noconfirm curl git less base-devel wget zsh python3 tmux htop btop vim nvim tree fzf jq zip unzip

# install yay
if [ ! -d ~/.nocture_tmp ]; then
    mkdir -p ~/.nocturne_tmp
fi

git clone https://aur.archlinux.org/yay-bin.git ~/.nocturne_tmp/yay
cd ~/.nocturne_tmp/yay-bin
makepkg -si --noconfirm

cd -
# clean up
rm -rf ~/.nocturne_tmp/yay

# install all shell tools
sudo pacman -Sy --noconfirm fastfetch github-cli lazydocker lazygit zellij fzf ripgrep bat eza zoxide plocate btop tldr fd

sudo pacman -Sy --noconfirm autoconf bison clang rust openssl readline libyaml readline zlib ncurses libffi gdbm jemalloc imagemagick mupdf mupdf-tools sqlite
