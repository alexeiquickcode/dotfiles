#!/bin/bash

# ------------------------------------------------------------------------------ 
# ---- Inputs ------------------------------------------------------------------
# ------------------------------------------------------------------------------ 

# Exits on errors and treats unset variables as errors
set -euo pipefail 

read -p "Enter Python version to install (default: 3.11.9): " PYTHON_VERSION
PYTHON_VERSION=${PYTHON_VERSION:-3.11.9} 

read -p "Enter NVM version to install (default: 0.39.7): " NVM_VERSION
NVM_VERSION=${NVM_VERSION:-0.39.7}

# ------------------------------------------------------------------------------ 
# ---- Low Level Dependencies -------------------------------------------------- 
# ------------------------------------------------------------------------------ 

sudo apt update && sudo apt upgrade -y

# Install essential packages
sudo apt install \
    wget \
    curl \
    git \
    zsh \
    openssh-client \
    tmux \
    ripgrep \
    htop \
    vim \
    neovim \
    stow \
    -y

# zsh 
chsh -s $(which zsh) # Make zsh the default shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" # Install OhMyZsh

# Install VPN
sudo apt-get install \
    openconnect \ 
    network-manager-openconnect \ 
    network-manager-openconnect-gnome \
    -y

# Install GNOME Extensions
sudo apt install \
    gnome-shell-extensions \
    chrome-gnome-shell \
    gnome-tweaks \
    -y

# Dependencies for building Python from source
sudo apt install \
    build-essential \     # Compiler tools (GCC/g++, make, etc.)
    libssl-dev \          # SSL support for HTTPS connections
    zlib1g-dev \          # Compression, required by the zlib module
    libbz2-dev \          # Compression, required by the bz2 module
    libreadline-dev \     # Command line interface handling
    libsqlite3-dev \      # SQLite database support
    llvm \                # For certain Python packages that may need LLVM
    libncurses5-dev \     # Text-based graphical interfaces
    libncursesw5-dev \    # Wide character support for text interfaces
    xz-utils \            # Handling LZMA compression
    tk-dev \              # Tkinter graphical interface development (matplotlib, seaborn etc.)
    libffi-dev \          # Foreign Function Interface
    liblzma-dev \         # LZMA compression algorithms
    xz-utils \            # XZ Compression format
    python3-openssl \     # OpenSSL support for Python
    -y

# Install for interfacing with the X11, specifically for the Xinerama extension
sudo apt-get install libxcb-xinerama0 -y

# Install DB packages
sudo apt-get install libmysqlclient-dev -y

# Install NVIDIA drivers
sudo ubuntu-drivers autoinstall

# ------------------------------------------------------------------------------ 
# ---- Programming Languages ---------------------------------------------------
# ------------------------------------------------------------------------------ 

# Install pyenv
curl https://pyenv.run | bash
eval "$(pyenv init --path)" # Ensure pyenv is available in the current session
pyenv install $PYTHON_VERSION
pyenv global $PYTHON_VERSION

# Install Node.js (via NVM)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # Loads NVM 
nvm install node # Installs the latest node version 
nvm use node

# ------------------------------------------------------------------------------ 
# ---- Applications ------------------------------------------------------------
# ------------------------------------------------------------------------------ 

# Install applications
sudo snap install code --classic
sudo snap install slack --classic
sudo snap install spotify
sudo snap install postman
sudo snap install datagrip --classic
sudo snap install pinta
sudo snap install libreoffice

echo "Installation completed."
