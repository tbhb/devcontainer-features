#!/bin/bash
set -e

# Test that just is installed and works
echo "Testing just installation..."

# Check just is in PATH
which just

# Check version output
just --version

# Test basic functionality
echo 'default:
    @echo "Hello from just!"' > /tmp/Justfile

cd /tmp && just

echo "All tests passed!"
