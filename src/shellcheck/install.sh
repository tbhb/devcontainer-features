#!/bin/bash
set -e

VERSION="${VERSION:-latest}"

echo "Installing ShellCheck ${VERSION}..."

# On Debian/Ubuntu, install via apt-get for "latest"
if [ "${VERSION}" = "latest" ] && command -v apt-get &> /dev/null; then
    apt-get update -q
    apt-get install -y --no-install-recommends shellcheck
    apt-get clean
    rm -rf /var/lib/apt/lists/*
    shellcheck --version
    echo "ShellCheck installed successfully"
    exit 0
fi

# Determine architecture (for specific version binary download)
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

# For specific versions: direct download (no API call needed)
DOWNLOAD_URL="https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/shellcheck-v${VERSION}.linux.${ARCH}.tar.xz"

echo "Downloading from ${DOWNLOAD_URL}..."

TMP_DIR=$(mktemp -d)
if ! curl -sL --fail --retry 3 --retry-delay 5 "${DOWNLOAD_URL}" -o "${TMP_DIR}/shellcheck.tar.xz"; then
    echo "ERROR: Failed to download shellcheck from ${DOWNLOAD_URL}"
    rm -rf "${TMP_DIR}"
    exit 1
fi

tar -xJf "${TMP_DIR}/shellcheck.tar.xz" -C "${TMP_DIR}"
mv "${TMP_DIR}"/shellcheck-*/shellcheck /usr/local/bin/
chmod +x /usr/local/bin/shellcheck
rm -rf "${TMP_DIR}"

shellcheck --version

echo "ShellCheck installed successfully"
