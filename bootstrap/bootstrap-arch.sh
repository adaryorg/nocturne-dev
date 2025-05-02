#little env prep
export PATH="$PATH:/$HOME/.local/bin"

# bare essentials
sudo pacman -Sy --noconfirm curl git less base-devel wget zsh python3 tmux htop btop vim nvim tree fzf jq zip unzip

# install yay
if [ ! -d ~/.nocture_tmp ]; then
    mkdir -p ~/.nocturne_tmp
fi

if [ -d ~/.nocturne_tmp/yay ]; then rm -rf ~/.nocturne_tmp/yay; fi
git clone https://aur.archlinux.org/yay-bin.git ~/.nocturne_tmp/yay
cd ~/.nocturne_tmp/yay
makepkg -si --noconfirm

cd -
# clean up
rm -rf ~/.nocturne_tmp/yay

# install all shell tools
sudo pacman -Sy --noconfirm fastfetch github-cli lazygit zellij fzf ripgrep bat eza zoxide plocate btop tldr fd

sudo pacman -Sy --noconfirm autoconf bison clang rust openssl readline libyaml readline zlib ncurses libffi gdbm jemalloc imagemagick mupdf mupdf-tools sqlite mise gnupg gum

yay -Sy --noconfirm lazydocker

# this will make me unpopular but we really do want all of gnome installed!
sudo pacman -Sy --noconfirm gnome

# install nerd fonts
sudo pacman -Sy --noconfirm ttf-firacode-nerd ttf-jetbrains-mono-nerd ttf-cascadia-mono-nerd ttf-meslo-nerdA

# some gnome stuff from AUR
yay -Sy --noconfirm extension-manager pipx
pipx install gnome-extensions-cli --system-site-packages
