#!/bin/bash
set -e

echo "Testing zsh-syntax-highlighting installation..."

# Check that the plugin file exists
if [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    echo "Found zsh-syntax-highlighting at /usr/share/zsh-syntax-highlighting/"
elif [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    echo "Found zsh-syntax-highlighting at /usr/share/zsh/plugins/zsh-syntax-highlighting/"
elif [ -f /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    echo "Found zsh-syntax-highlighting at /usr/local/share/zsh-syntax-highlighting/"
else
    echo "ERROR: zsh-syntax-highlighting not found"
    exit 1
fi

# Check profile script exists
if [ -f /etc/profile.d/zsh-syntax-highlighting.sh ]; then
    echo "Profile script found"
else
    echo "ERROR: Profile script not found"
    exit 1
fi

echo "All tests passed!"
