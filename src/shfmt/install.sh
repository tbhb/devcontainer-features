#!/bin/bash
set -e

VERSION="${VERSION:-latest}"

echo "Installing shfmt ${VERSION}..."

# Build curl auth header if GITHUB_TOKEN is available (helps with rate limits)
CURL_OPTS=(-sL --fail --retry 3 --retry-delay 5)
if [ -n "${GITHUB_TOKEN}" ]; then
    CURL_OPTS+=(-H "Authorization: token ${GITHUB_TOKEN}")
fi

# Determine architecture
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64) ARCH="amd64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)
        echo "ERROR: Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

# Resolve version
if [ "${VERSION}" = "latest" ]; then
    echo "Fetching latest release info from GitHub API..."
    if ! RELEASE_INFO=$(curl "${CURL_OPTS[@]}" https://api.github.com/repos/mvdan/sh/releases/latest); then
        echo "ERROR: Failed to fetch release info from GitHub API"
        echo "This may be due to rate limiting. Set GITHUB_TOKEN to authenticate."
        exit 1
    fi

    # Extract tag name to get version
    if command -v jq &> /dev/null; then
        TAG_NAME=$(echo "${RELEASE_INFO}" | jq -r ".tag_name")
    else
        TAG_NAME=$(echo "${RELEASE_INFO}" | grep -o '"tag_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | cut -d '"' -f 4)
    fi

    if [ -z "${TAG_NAME}" ] || [ "${TAG_NAME}" = "null" ]; then
        echo "ERROR: Could not find tag name in release info"
        echo "API response (first 500 chars): ${RELEASE_INFO:0:500}"
        exit 1
    fi

    echo "Found latest release: ${TAG_NAME}"
else
    TAG_NAME="v${VERSION}"
fi

# Download binary (shfmt releases are raw binaries, not archives)
BINARY_NAME="shfmt_${TAG_NAME}_linux_${ARCH}"
DOWNLOAD_URL="https://github.com/mvdan/sh/releases/download/${TAG_NAME}/${BINARY_NAME}"

echo "Downloading from ${DOWNLOAD_URL}..."

TMP_DIR=$(mktemp -d)
if ! curl "${CURL_OPTS[@]}" "${DOWNLOAD_URL}" -o "${TMP_DIR}/shfmt"; then
    echo "ERROR: Failed to download shfmt from ${DOWNLOAD_URL}"
    rm -rf "${TMP_DIR}"
    exit 1
fi

mv "${TMP_DIR}/shfmt" /usr/local/bin/shfmt
chmod +x /usr/local/bin/shfmt
rm -rf "${TMP_DIR}"

# Verify installation
shfmt --version

echo "shfmt installed successfully"
