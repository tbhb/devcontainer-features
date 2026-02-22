#!/bin/bash
set -e

# Test that a specific version of shfmt is installed
echo "Testing shfmt version installation..."

# Check shfmt is in PATH
which shfmt

# Check version output contains expected version
VERSION=$(shfmt --version)
echo "Installed version: ${VERSION}"

# The scenarios.json specifies version 3.12.0
if [[ "${VERSION}" == *"3.12.0"* ]]; then
    echo "Version check passed!"
else
    echo "ERROR: Expected version 3.12.0 but got ${VERSION}"
    exit 1
fi

echo "All tests passed!"
