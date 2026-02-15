#!/bin/bash
set -e

echo "Testing Biome installation..."

# Check biome is in PATH
which biome

# Check version output
biome --version

# Test basic functionality - format and write
echo '{"name": "test"}' > /tmp/test.json
biome format --write /tmp/test.json

# Test linting on valid JS
echo 'const x = 1;
console.log(x);' > /tmp/test.js
biome lint /tmp/test.js

echo "All tests passed!"
