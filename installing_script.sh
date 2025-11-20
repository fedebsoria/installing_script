#!/usr/bin/env bash

VERSION="v0.2"


set -o noclobber  # Avoid overlay files (echo "hi" > foo)
#Tempoorary commented for testing al elements in the library
#set -o errexit     Used to exit upon error, avoiding cascading errors
set -o pipefail   # Unveils hidden failures
set -o nounset    # Exposes unset variables

apps_to_install=(
    "fish"
    "jq"
    "bat"
    "ripgrep"
    "htop"
    "fd-find"
    "tmux"
    "git"
)

# Function to see if the app is install, if not install it.
if_doesnt_exist_install() {
    local programa="$1"

    # Security check to see if there's an argument
    if [ -z "$programa" ]; then
        # Send error to "stderr"
        echo "Error: No has especificado un programa." >&2
        return 1
    fi

    # Instalation check
    if ! command -v "$programa" &> /dev/null
    then
        echo "The program '$programa' isn't installed. Installing..."
        sudo apt install "$programa" -y -qq
        echo "'$programa' Installed!"
    else
        echo "..."
    fi
}

## Create functions for permanents alias
create_alias_fish() {
    local program_to_alias="$1"
    local alias="$2"

    if [ -z "$program_to_alias" ] || [ -z "$alias" ]; then
        echo "Error: missing arguments." >&2
        return 1
    fi

    echo "Creating alias '$alias' for '$program_to_alias' in Fish..."
    fish -c "function $alias; $program_to_alias \$argv; end; funcsave $alias"
}

####### START INSTALLING #######
echo "🚀 Starting installation of required packages..."
sudo apt update -y -qq

# Calls installation function

for val in "${apps_to_install[@]}"; do
    if_doesnt_exist_install $val
done

# Autoremove unused packages
echo "🧹 Cleaning up unused packages..."
sudo apt autoremove -y -qq

# Make Fish default interpreter
echo "🛠️ making fish the default interpreter"
if [ -n "${SUDO_USER-}" ]; then
    # Change shell for the invoking (non-root) user when run under sudo
    chsh -s /usr/bin/fish "$SUDO_USER" || echo "(Warning) Could not change shell for $SUDO_USER"
else
    chsh -s /usr/bin/fish || echo "(Warning) Could not change shell for current user"
fi

# Create aliases for bat y fd-fin
echo "🛠️ Creating alias for fd, bat, rg "
create_alias_fish "batcat" "bat"
create_alias_fish "fd-find" "fd"
create_alias_fish "ripgrep" "rg"
echo "💪 Aliases created successfully inside fish (saved with funcsave)."
