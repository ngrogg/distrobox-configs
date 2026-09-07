#!/usr/bin/env bash

# Dev Box
# BASH script to configure distrobox container for development
# By Nicholas Grogg
# Revision: TODO

# Set exit on error
set -e
# Uncomment for error on unset variables
# set -u
# Uncomment for exit on non-zero status from rightmost pipe command
# set -o pipefail

# Create container
distrobox create --image fedora:latest --name dev_box

# Update container
distrobox enter dev_environment -- sudo dnf update -y

# Install packages on container, change as needed
distrobox enter dev_environment -- sudo dnf install -y \
    ansible \
    cmake \
    gcc-c++ \
    git \
    ksshaskpass \
    make \
    perl-JSON \
    perl-XML-LibXML \
    perl-XML-Simple \
    python3 \
    python3-devel \
    python3-pip \
    vim-enhanced \
    wl-clipboard \
    zsh

# Download/place zsh/vim rc files
distrobox enter dev_box -- wget -O .zshrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.zshrc
distrobox enter dev_box -- wget -O .vimrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.vimrc.simple

# Create related vim/zsh directories
distrobox enter dev_box -- mkdir -p .zsh/cache
distrobox enter dev_box -- mkdir -p .vim/backupdir

# Set container shell
distrobox enter dev_box -- chsh -s $(which zsh)
