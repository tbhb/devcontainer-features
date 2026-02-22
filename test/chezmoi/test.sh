#!/bin/bash
set -e

echo "Testing chezmoi installation..."

which chezmoi
chezmoi --version

# Test that chezmoi can initialize without a repo
chezmoi init
chezmoi data | grep -q "os"

echo "All tests passed!"
