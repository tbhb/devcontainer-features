#!/bin/bash
set -e

VERSION="${VERSION:-latest}"

echo "Installing tmux ${VERSION}..."

# On Debian/Ubuntu, install via apt-get for "latest"
if [ "${VERSION}" = "latest" ] && command -v apt-get &> /dev/null; then
    apt-get update -q
    apt-get install -y --no-install-recommends tmux
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    tmux -V
    echo "tmux installed successfully"
    exit 0
fi

# Determine architecture (for specific version binary download)
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)
        echo "Unsupported architecture: ${ARCH}, falling back to apt"
        if command -v apt-get &> /dev/null; then
            apt-get update -q
            apt-get install -y --no-install-recommends tmux
            apt-get clean
            rm -rf /var/lib/apt/lists/*
            tmux -V
            exit 0
        else
            echo "ERROR: Unsupported architecture and no apt available"
            exit 1
        fi
        ;;
esac

# For specific versions: direct download from tmux-builds (no API call needed)
# Tags use v prefix but asset filenames don't
DOWNLOAD_URL="https://github.com/tmux/tmux-builds/releases/download/v${VERSION}/tmux-${VERSION}-linux-${ARCH}.tar.gz"

echo "Downloading from ${DOWNLOAD_URL}..."

TMP_DIR=$(mktemp -d)
if ! curl -sL --fail --retry 3 --retry-delay 5 "${DOWNLOAD_URL}" -o "${TMP_DIR}/tmux.tar.gz"; then
    echo "ERROR: Failed to download tmux from ${DOWNLOAD_URL}"
    rm -rf "${TMP_DIR}"
    exit 1
fi

tar -xzf "${TMP_DIR}/tmux.tar.gz" -C "${TMP_DIR}"
mv "${TMP_DIR}/tmux" /usr/local/bin/tmux
chmod +x /usr/local/bin/tmux
rm -rf "${TMP_DIR}"

tmux -V

echo "tmux installed successfully"
