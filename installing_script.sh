#!/usr/bin/env bash
set -o noclobber  # Avoid overlay files (echo "hi" > foo)
set -o errexit    # Used to exit upon error, avoiding cascading errors
set -o pipefail   # Unveils hidden failures
set -o nounset    # Exposes unset variables

apps_to_install=(
    "jq"
    "eza"
    "batcat"
    "rg"
    "htop"
    "alacritty"
    "fish"
    "fd-find"
    "tmux"
    "git"
)

echo "🚀 Starting installation of required packages..."
sudo apt update -y -qq

### Checks if the commands and apps are installed
### if not, installs them using apt:

for val in "${apps_to_install[@]}"; do
    if [ $val == fd-find ]; then
        val="fdfind"  # fd-find package command is fdfind
    fi

    if  [ -x "$(command -v $val)" ]; then
        echo "✅ $val is installed" >&2
    else
        echo "😤 $val is not installed, 🚀 installing..." >&2
        sudo apt install -y -qq "$val"
    fi
done

## Autoremove unused packages
echo "🧹 Cleaning up unused packages..."
sudo apt autoremove -y -qq

##Creates a symlinks
if [ ! -f ~/.local/bin/fd ] || [ ! -f ~/.local/bin/bat ]; then
    echo "🛠️ Creating symlinks for fd and bat "
    if [ ! -d ~/.local/bin ]; then
    mkdir -p ~/.local/bin
    elif [ -d ~/.local/bin ]; then
        echo "Directory ~/.local/bin already exists, skipping creation."
    fi
    sudo ln -s $(which fdfind) ~/.local/bin/fd
    sudo ln -s $(which batcat) ~/.local/bin/bat
    echo "💪 Symlinks created successfully."
fi



