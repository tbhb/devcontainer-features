#!/bin/bash
set -e

echo "Testing tmux installation..."

# Check tmux is in PATH
which tmux

# Check version output
tmux -V

# Test basic functionality: start a detached session, list it, kill it
tmux new-session -d -s test-session
tmux list-sessions | grep test-session
tmux kill-session -t test-session

echo "All tests passed!"
