#!/bin/bash
set -e

# Test that a specific version of tmux is installed
echo "Testing tmux version installation..."

# Check tmux is in PATH
which tmux

# Check version output contains expected version
VERSION=$(tmux -V)
echo "Installed version: ${VERSION}"

# The scenarios.json specifies version 3.6a
# tmux -V outputs "tmux 3.6a"
if [[ "${VERSION}" == *"3.6a"* ]]; then
    echo "Version check passed!"
else
    echo "ERROR: Expected version 3.6a but got ${VERSION}"
    exit 1
fi

echo "All tests passed!"
