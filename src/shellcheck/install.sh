#!/bin/bash
set -e

VERSION="${VERSION:-latest}"

echo "Installing ShellCheck ${VERSION}..."

# Determine architecture
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64) ARCH="x86_64" ;;
    aarch64|arm64) ARCH="aarch64" ;;
    armv6l|armv7l) ARCH="armv6hf" ;;
    *)
        echo "Unsupported architecture: ${ARCH}, falling back to apt"
        if command -v apt-get &> /dev/null; then
            apt-get update
            apt-get install -y --no-install-recommends shellcheck
            apt-get clean
            rm -rf /var/lib/apt/lists/*
            shellcheck --version
            exit 0
        else
            echo "ERROR: Unsupported architecture and no apt available"
            exit 1
        fi
        ;;
esac

# Get download URL
if [ "${VERSION}" = "latest" ]; then
    DOWNLOAD_URL=$(curl -s https://api.github.com/repos/koalaman/shellcheck/releases/latest \
        | grep "browser_download_url.*linux\.${ARCH}\.tar\.xz" \
        | cut -d '"' -f 4)
    if [ -z "${DOWNLOAD_URL}" ]; then
        echo "ERROR: Could not find download URL for architecture ${ARCH}"
        exit 1
    fi
else
    DOWNLOAD_URL="https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/shellcheck-v${VERSION}.linux.${ARCH}.tar.xz"
fi

echo "Downloading from ${DOWNLOAD_URL}..."

# Download and install
TMP_DIR=$(mktemp -d)
curl -sSL "${DOWNLOAD_URL}" -o "${TMP_DIR}/shellcheck.tar.xz"
tar -xJf "${TMP_DIR}/shellcheck.tar.xz" -C "${TMP_DIR}"
mv "${TMP_DIR}"/shellcheck-*/shellcheck /usr/local/bin/
chmod +x /usr/local/bin/shellcheck
rm -rf "${TMP_DIR}"

# Verify installation
shellcheck --version

echo "ShellCheck installed successfully"
