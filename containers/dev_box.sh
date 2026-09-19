#!/usr/bin/env bash

# Dev Box
# BASH script to configure distrobox container for development
# By Nicholas Grogg
# Revision: 20260919

# Set exit on error
set -e
# Uncomment for error on unset variables
set -u

# Create container
distrobox-create --image fedora:latest --name dev_box

# Update container
distrobox-upgrade dev_box

# Install packages on container, change as needed
distrobox-enter dev_box -- sudo dnf install -y \
    ansible \
    cmake \
    gcc-c++ \
    make \
    perl-JSON \
    perl-XML-LibXML \
    perl-XML-Simple \
    python3 \
    python3-devel \
    python3-pip \
    tmux \
    vim-enhanced \
    zsh

# Download/place tmux/vim/zsh rc files
distrobox-enter dev_box -- wget -O .vimrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.tmux.conf
distrobox-enter dev_box -- wget -O .vimrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.vimrc.simple
distrobox-enter dev_box -- wget -O .zshrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.zshrc

# Create related vim/zsh directories
distrobox-enter dev_box -- mkdir -p .zsh/cache
distrobox-enter dev_box -- mkdir -p .vim/backupdir

# Set container shell
distrobox-enter dev_box -- chsh -s /usr/bin/zsh
