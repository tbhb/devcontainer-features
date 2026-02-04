#!/bin/bash
set -e

VERSION="${VERSION:-latest}"

echo "Installing just ${VERSION}..."

# Determine architecture
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    *)
        echo "Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

# Install just
if [ "${VERSION}" = "latest" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin
else
    curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --tag "${VERSION}" --to /usr/local/bin
fi

# Verify installation
just --version

echo "just installed successfully"
