#!/bin/bash
set -e

# Test that a specific version of shellcheck is installed
echo "Testing ShellCheck version installation..."

# Check shellcheck is in PATH
which shellcheck

# Check version output contains expected version
VERSION=$(shellcheck --version | grep "^version:" | awk '{print $2}')
echo "Installed version: ${VERSION}"

# The scenarios.json specifies version 0.10.0
if [[ "${VERSION}" == "0.10.0" ]]; then
    echo "Version check passed!"
else
    echo "ERROR: Expected version 0.10.0 but got ${VERSION}"
    exit 1
fi

echo "All tests passed!"
