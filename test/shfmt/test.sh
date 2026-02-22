#!/bin/bash
set -e

echo "Testing shfmt installation..."

# Check shfmt is in PATH
which shfmt

# Check version output
shfmt --version

# Test basic formatting - write unformatted script to file
cat > /tmp/shfmt-test.sh << 'SCRIPT'
#!/bin/bash
if [ -n "hello" ]; then
echo "world"
fi
SCRIPT

FORMATTED=$(shfmt /tmp/shfmt-test.sh)
echo "Formatted output:"
echo "${FORMATTED}"

# Verify shfmt actually changed the indentation
if echo "${FORMATTED}" | grep -q '	echo'; then
    echo "Formatting check passed!"
else
    echo "ERROR: shfmt did not produce expected formatted output"
    exit 1
fi

echo "All tests passed!"
