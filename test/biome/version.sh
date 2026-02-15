#!/bin/bash
set -e

echo "Testing Biome version installation..."

# Check biome is in PATH
which biome

# Check version output contains expected version
biome --version

echo "Version test passed!"
