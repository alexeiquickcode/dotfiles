#!/bin/bash

# ------------------------------------------------------------------------------
# ---- Inputs ------------------------------------------------------------------
# ------------------------------------------------------------------------------

set -euo pipefail # Exits on errors and treats unset variables as errors

read -p "Enter Python version to install (default: 3.12.9): " PYTHON_VERSION
PYTHON_VERSION=${PYTHON_VERSION:-3.12.9}

read -p "Enter NVM version to install (default: 0.40.1): " NVM_VERSION
NVM_VERSION=${NVM_VERSION:-0.40.1}

# ------------------------------------------------------------------------------
# ---- Low Level Dependencies --------------------------------------------------
# ------------------------------------------------------------------------------

# Install yay (AUR helper)
if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd .. && rm -rf yay
fi

# Update system and install essential packages
sudo pacman -Syu --noconfirm

sudo pacman -S --noconfirm xclip xl-clipboard # To be able to copy and paste to nvim (xclip for x11)

# Install essential packages
sudo pacman -S --noconfirm \
    wget \
    curl \
    git \
    lazygit \
    git-delta \
    zsh \
    openssh \
    tmux \
    ripgrep \
    htop \
    vim \
    neovim \
    stow \
    base-devel \
    tk \
    xz \
    libffi \
    mariadb-libs \
    python-pyopenssl \
    ghostty

# Set zsh as the default shell
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install zsh plugsins 
yay -S --noconfirm zsh-syntax-highlighting zsh-autosuggestions

# Install starship
curl -sS https://starship.rs/install.sh | sh -s -- -y

# Install Nerd Fonts globally
NERD_FONT="CascadiaCode"
sudo mkdir -p /usr/share/fonts/NerdFonts
cd /usr/share/fonts/NerdFonts
sudo curl -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${NERD_FONT}.zip
sudo unzip -o ${NERD_FONT}.zip
sudo rm ${NERD_FONT}.zip
fc-cache -fv

# Install NVIDIA drivers if applicable
if lspci | grep -i nvidia; then # TODO: Already installed in arch installer?
    sudo pacman -S --noconfirm nvidia nvidia-utils
fi

# Install dependencies for building Python from source
# TODO: Consolidate with the *essential packages* above
sudo pacman -S --noconfirm --needed \
    base-devel \
    openssl \
    zlib \
    bzip2 \
    readline \
    sqlite \
    llvm \
    ncurses \
    xz \
    tk \
    libffi \
    python-pyopenssl \
    python-build

# ------------------------------------------------------------------------------
# ---- Programming Languages ---------------------------------------------------
# ------------------------------------------------------------------------------

# Install pyenv
curl https://pyenv.run | bash
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"

# Install Python
pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION

# Install global Python packages
pip install basedpyright visidata yapf isort

# Install debugpy for nvim
sudo pacman -S --noconfirm --needed python-debugpy
mkdir ~/.virtualenvs
cd ~/.virtualenvs
python -m venv debugpy
debugpy/bin/python -m pip install debugpy

# Install Node.js (via NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
nvm install node
nvm use node

# ------------------------------------------------------------------------------
# ---- Applications ------------------------------------------------------------
# ------------------------------------------------------------------------------

# Install apps
yay -S --noconfirm \
    visual-studio-code-bin \
    slack-desktop \
    spotify \
    postman-bin \
    datagrip \
    pinta \
    libreoffice-fresh \
    aws-cli-v2 \
    lens-bin


# ------------------------------------------------------------------------------
# ---- Hyprland ----------------------------------------------------------------
# ------------------------------------------------------------------------------

pacman -S --noconfirm \
    waybar \
    rofi \
    thunar \
    hypridle \
    xdg-desktop-portal-hyprland \
    swappy

yay -S --noconfirm \
    swww 

# ------------------------------------------------------------------------------
# ---- Dotfiles ----------------------------------------------------------------
# ------------------------------------------------------------------------------

git clone https://github.com/alexeiquickcode/dotfiles.git ~/dotfiles
cd ~/dotfiles

rm -f ~/.zshrc # Will install with stow
stow --ignore='scripts' */

# ------------------------------------------------------------------------------

echo "Installation completed successfully. Reboot now!"
