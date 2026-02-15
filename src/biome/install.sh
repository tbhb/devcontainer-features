#!/bin/bash
set -e

BIOME_VERSION="${VERSION:-latest}"

echo "Installing Biome ${BIOME_VERSION}..."

# Build curl auth header if GITHUB_TOKEN is available (helps with rate limits)
CURL_OPTS=(-sL --fail --retry 3 --retry-delay 5)
if [ -n "${GITHUB_TOKEN}" ]; then
    CURL_OPTS+=(-H "Authorization: token ${GITHUB_TOKEN}")
fi

# Determine architecture
ARCH=$(uname -m)
case "${ARCH}" in
    x86_64) ARCH="x64" ;;
    aarch64|arm64) ARCH="arm64" ;;
    *)
        echo "ERROR: Unsupported architecture: ${ARCH}"
        exit 1
        ;;
esac

# Detect musl (Alpine) vs glibc
LIBC=""
if [ -f /etc/os-release ]; then
    # shellcheck source=/dev/null
    . /etc/os-release
    if [ "${ID}" = "alpine" ]; then
        LIBC="-musl"
    fi
elif ldd --version 2>&1 | grep -q musl; then
    LIBC="-musl"
fi

BINARY_NAME="biome-linux-${ARCH}${LIBC}"

# Get download URL
if [ "${BIOME_VERSION}" = "latest" ]; then
    echo "Fetching latest release info from GitHub API..."
    if ! RELEASE_INFO=$(curl "${CURL_OPTS[@]}" https://api.github.com/repos/biomejs/biome/releases/latest); then
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
    DOWNLOAD_URL="https://github.com/biomejs/biome/releases/download/${TAG_NAME}/${BINARY_NAME}"
else
    # Biome uses @biomejs/biome@VERSION tag format
    DOWNLOAD_URL="https://github.com/biomejs/biome/releases/download/@biomejs/biome@${BIOME_VERSION}/${BINARY_NAME}"
fi

echo "Downloading from ${DOWNLOAD_URL}..."

# Download and install
TMP_DIR=$(mktemp -d)
if ! curl "${CURL_OPTS[@]}" "${DOWNLOAD_URL}" -o "${TMP_DIR}/biome"; then
    echo "ERROR: Failed to download biome from ${DOWNLOAD_URL}"
    rm -rf "${TMP_DIR}"
    exit 1
fi

mv "${TMP_DIR}/biome" /usr/local/bin/biome
chmod +x /usr/local/bin/biome
rm -rf "${TMP_DIR}"

# Verify installation
biome --version

echo "Biome installed successfully"
