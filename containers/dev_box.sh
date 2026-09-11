#!/usr/bin/env bash

# Dev Box
# BASH script to configure distrobox container for development
# By Nicholas Grogg
# Revision: 20260907

# Set exit on error
set -e
# Uncomment for error on unset variables
set -u

# Variables
## Name for gitconfig
local gitUsername="$1"

## Email for gitconfig
local gitEmail="$2"

# Create container
distrobox-create --image fedora:latest --name dev_box

# Update container
distrobox-upgrade dev_box

# Install packages on container, change as needed
distrobox-enter dev_box -- sudo dnf install -y \
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
    zsh

# Download/place zsh/vim rc files
distrobox-enter dev_box -- wget -O .zshrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.zshrc
distrobox-enter dev_box -- wget -O .vimrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.vimrc.simple

# Create related vim/zsh directories
distrobox-enter dev_box -- mkdir -p .zsh/cache
distrobox-enter dev_box -- mkdir -p .vim/backupdir

# Set gitconfig
## Variable checks
if [[ -z "$gitUsername" ]]; then
    read -p "Enter a username for git commits" : gitUsername
fi

if [[ -z "$gitEmail" ]]; then
    read -p "Enter an email for git commits" : gitEmail
fi

## Set git configs
distrobox-enter dev_box -- git config --global user.name "$gitUsername"
distrobox-enter dev_box -- git config --global user.email "$gitEmail"

# Set container shell
distrobox-enter dev_box -- chsh -s /usr/bin/zsh
