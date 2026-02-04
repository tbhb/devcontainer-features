#!/bin/bash
set -e

echo "Testing zsh-autosuggestions installation..."

# Check that the plugin file exists
if [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    echo "Found zsh-autosuggestions at /usr/share/zsh-autosuggestions/"
elif [ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    echo "Found zsh-autosuggestions at /usr/share/zsh/plugins/zsh-autosuggestions/"
elif [ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    echo "Found zsh-autosuggestions at /usr/local/share/zsh-autosuggestions/"
else
    echo "ERROR: zsh-autosuggestions not found"
    exit 1
fi

# Check profile script exists
if [ -f /etc/profile.d/zsh-autosuggestions.sh ]; then
    echo "Profile script found"
else
    echo "ERROR: Profile script not found"
    exit 1
fi

echo "All tests passed!"
