#!/bin/bash
set -e

VERSION="${VERSION:-latest}"

echo "Installing chezmoi ${VERSION}..."

# Build install script arguments
INSTALL_ARGS=("-b" "/usr/local/bin")

if [ "${VERSION}" != "latest" ]; then
    INSTALL_ARGS+=("-t" "v${VERSION}")
fi

# Install chezmoi using the official installer
sh -c "$(curl -fsLS get.chezmoi.io)" -- "${INSTALL_ARGS[@]}"

# Verify installation
chezmoi --version

echo "chezmoi installed successfully"
