#!/bin/bash
set -e

echo "Installing zsh-autosuggestions..."

# Detect package manager and install
if command -v apt-get &> /dev/null; then
    apt-get update
    apt-get install -y --no-install-recommends zsh-autosuggestions
    apt-get clean
    rm -rf /var/lib/apt/lists/*

    # The apt package installs to /usr/share
    ZSH_AUTOSUGGESTIONS_PATH="/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
elif command -v apk &> /dev/null; then
    apk add --no-cache zsh-autosuggestions
    ZSH_AUTOSUGGESTIONS_PATH="/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
else
    # Fall back to git clone
    ZSH_AUTOSUGGESTIONS_DIR="/usr/local/share/zsh-autosuggestions"
    git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_AUTOSUGGESTIONS_DIR}"
    ZSH_AUTOSUGGESTIONS_PATH="${ZSH_AUTOSUGGESTIONS_DIR}/zsh-autosuggestions.zsh"
fi

# Create a profile script to source the plugin
cat > /etc/profile.d/zsh-autosuggestions.sh << EOF
# zsh-autosuggestions
if [ -n "\$ZSH_VERSION" ] && [ -f "${ZSH_AUTOSUGGESTIONS_PATH}" ]; then
    source "${ZSH_AUTOSUGGESTIONS_PATH}"
fi
EOF

echo "zsh-autosuggestions installed successfully"
