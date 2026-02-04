#!/bin/bash
set -e

echo "Testing ShellCheck installation..."

# Check shellcheck is in PATH
which shellcheck

# Check version output
shellcheck --version

# Test basic functionality
echo '#!/bin/bash
echo "hello"' > /tmp/test.sh
shellcheck /tmp/test.sh

echo "All tests passed!"
