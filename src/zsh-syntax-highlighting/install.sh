#!/bin/bash
set -e

echo "Installing zsh-syntax-highlighting..."

# Detect package manager and install
if command -v apt-get &> /dev/null; then
    apt-get update
    apt-get install -y --no-install-recommends zsh-syntax-highlighting
    apt-get clean
    rm -rf /var/lib/apt/lists/*

    # The apt package installs to /usr/share
    ZSH_SYNTAX_HIGHLIGHTING_PATH="/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif command -v apk &> /dev/null; then
    apk add --no-cache zsh-syntax-highlighting
    ZSH_SYNTAX_HIGHLIGHTING_PATH="/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
else
    # Fall back to git clone
    ZSH_SYNTAX_HIGHLIGHTING_DIR="/usr/local/share/zsh-syntax-highlighting"
    git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_SYNTAX_HIGHLIGHTING_DIR}"
    ZSH_SYNTAX_HIGHLIGHTING_PATH="${ZSH_SYNTAX_HIGHLIGHTING_DIR}/zsh-syntax-highlighting.zsh"
fi

# Create a profile script to source the plugin
# Note: syntax-highlighting should be sourced AFTER other plugins
cat > /etc/profile.d/zsh-syntax-highlighting.sh << EOF
# zsh-syntax-highlighting (should be sourced last)
if [ -n "\$ZSH_VERSION" ] && [ -f "${ZSH_SYNTAX_HIGHLIGHTING_PATH}" ]; then
    source "${ZSH_SYNTAX_HIGHLIGHTING_PATH}"
fi
EOF

echo "zsh-syntax-highlighting installed successfully"
