#!/bin/bash
set -e

VERSION="${VERSION:-latest}"

echo "Installing ShellCheck ${VERSION}..."

# Build curl auth header if GITHUB_TOKEN is available (helps with rate limits)
CURL_OPTS=(-sL --fail --retry 3 --retry-delay 5)
if [ -n "${GITHUB_TOKEN}" ]; then
    CURL_OPTS+=(-H "Authorization: token ${GITHUB_TOKEN}")
fi

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
    echo "Fetching latest release info from GitHub API..."
    if ! RELEASE_INFO=$(curl "${CURL_OPTS[@]}" https://api.github.com/repos/koalaman/shellcheck/releases/latest); then
        echo "ERROR: Failed to fetch release info from GitHub API"
        echo "This may be due to rate limiting. Set GITHUB_TOKEN to authenticate."
        exit 1
    fi

    # Try jq first if available, otherwise use grep
    if command -v jq &> /dev/null; then
        DOWNLOAD_URL=$(echo "${RELEASE_INFO}" | jq -r ".assets[] | select(.name | contains(\"linux.${ARCH}.tar.xz\")) | .browser_download_url")
    else
        DOWNLOAD_URL=$(echo "${RELEASE_INFO}" | grep -oP "\"browser_download_url\":\s*\"[^\"]*linux\.${ARCH}\.tar\.xz\"" | cut -d '"' -f 4)
    fi

    if [ -z "${DOWNLOAD_URL}" ] || [ "${DOWNLOAD_URL}" = "null" ]; then
        echo "ERROR: Could not find download URL for architecture ${ARCH}"
        echo "API response: ${RELEASE_INFO}" | head -50
        exit 1
    fi
else
    DOWNLOAD_URL="https://github.com/koalaman/shellcheck/releases/download/v${VERSION}/shellcheck-v${VERSION}.linux.${ARCH}.tar.xz"
fi

echo "Downloading from ${DOWNLOAD_URL}..."

# Download and install
TMP_DIR=$(mktemp -d)
if ! curl "${CURL_OPTS[@]}" "${DOWNLOAD_URL}" -o "${TMP_DIR}/shellcheck.tar.xz"; then
    echo "ERROR: Failed to download shellcheck from ${DOWNLOAD_URL}"
    rm -rf "${TMP_DIR}"
    exit 1
fi

# Verify it's actually an xz archive before extracting
if ! file "${TMP_DIR}/shellcheck.tar.xz" | grep -q "XZ compressed"; then
    echo "ERROR: Downloaded file is not a valid XZ archive"
    echo "File type: $(file "${TMP_DIR}/shellcheck.tar.xz")"
    echo "First 100 bytes:"
    head -c 100 "${TMP_DIR}/shellcheck.tar.xz"
    rm -rf "${TMP_DIR}"
    exit 1
fi

tar -xJf "${TMP_DIR}/shellcheck.tar.xz" -C "${TMP_DIR}"
mv "${TMP_DIR}"/shellcheck-*/shellcheck /usr/local/bin/
chmod +x /usr/local/bin/shellcheck
rm -rf "${TMP_DIR}"

# Verify installation
shellcheck --version

echo "ShellCheck installed successfully"
