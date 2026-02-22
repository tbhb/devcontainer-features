#!/bin/bash
set -e

echo "Testing chezmoi version installation..."

which chezmoi

VERSION=$(chezmoi --version | head -1)
echo "Installed version: ${VERSION}"

if [[ "${VERSION}" == *"2.69.4"* ]]; then
    echo "Version check passed!"
else
    echo "ERROR: Expected version 2.69.4 but got ${VERSION}"
    exit 1
fi

echo "All tests passed!"
