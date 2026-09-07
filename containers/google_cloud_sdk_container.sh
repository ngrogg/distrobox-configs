#!/usr/bin/env bash

# Google Cloud SDK Container
# Configure a Distrobox container for running the Google Cloud SDK
# By Nicholas Grogg
# Revision: 20260907

# Set exit on error
set -e
# Uncomment for error on unset variables
# set -u
# Uncomment for exit on non-zero status from rightmost pipe command
# set -o pipefail

# Variables
## Variable for default Google Cloud SDK project
local defaultProject="$1"

## Variable for default cluster
local defaultCluster="$2"

## Variable for default cluster zone
local defaultClusterZone="$3"

# Create container
distrobox-create --name google_cloud_sdk_container --image almalinux:10

# Update container
distrobox-upgrade google_cloud_sdk_container

# Download/place zsh/vim rc files
distrobox-enter google_cloud_sdk_container -- wget -O .zshrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.zshrc
distrobox-enter google_cloud_sdk_container -- wget -O .vimrc https://raw.githubusercontent.com/ngrogg/dotfiles/refs/heads/main/.vimrc.simple

# Create related vim/zsh directories
distrobox-enter google_cloud_sdk_container -- mkdir -p .zsh/cache
distrobox-enter google_cloud_sdk_container -- mkdir -p .vim/backupdir

# Set container shell
distrobox-enter google_cloud_sdk_container -- chsh -s /usr/bin/zsh

# Create Google Cloud SDK repo
distrobox-enter google_cloud_sdk_container -- sudo tee -a /etc/yum.repos.d/google-cloud-sdk.repo << EOM
[google-cloud-cli]
name=Google Cloud CLI
baseurl=https://packages.cloud.google.com/yum/repos/cloud-sdk-el10-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key-v10.gpg
EOM

# Install Gcloud SDK dependencies
distrobox-enter google_cloud_sdk_container -- sudo dnf install -y libxcrypt-compat

# Install Gcloud SDK
distrobox-enter google_cloud_sdk_container -- sudo dnf install -y google-cloud-cli

# Initialize Gcloud SDK
distrobox-enter google_cloud_sdk_container -- gcloud init

# If project was not passed, prompt user to enter default project
if [[ -z "$defaultProject" ]]; then
    read -p "Enter a project to use: " defaultProject
fi

# Set default project
distrobox-enter google_cloud_sdk_container -- gcloud config set project "$defaultProject"

# Install Kubectl
distrobox-enter google_cloud_sdk_container -- sudo dnf install -y kubectl

# Install Kubectl auth plugin
distrobox-enter google_cloud_sdk_container -- sudo dnf install -y google-cloud-sdk-gke-gcloud-auth-plugin

# If default cluster was not passed
if [[ -z "$defaultCluster" ]]; then
    read -p "Enter the default cluster name to use: " defaultCluster
fi

# If default cluster zone was not passed
if [[ -z "$defaultClusterZone" ]]; then
    read -p "Enter the zone of the default cluster to use: " defaultClusterZone
fi

# Authorize default cluster
distrobox-enter google_cloud_sdk_container -- gcloud container clusters get-credentials "$defaultCluster" --zone="$defaultClusterZone"
