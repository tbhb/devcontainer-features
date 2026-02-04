#!/bin/bash
set -e

# Test that a specific version of just is installed
echo "Testing just version installation..."

# Check just is in PATH
which just

# Check version output contains expected version
VERSION=$(just --version | head -1)
echo "Installed version: ${VERSION}"

# The scenarios.json specifies version 1.40.0
if [[ "${VERSION}" == *"1.40.0"* ]]; then
    echo "Version check passed!"
else
    echo "ERROR: Expected version 1.40.0 but got ${VERSION}"
    exit 1
fi

echo "All tests passed!"
