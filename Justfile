# Dev Container Features
# https://github.com/tbhb/devcontainer-features

set shell := ['uv', 'run', '--frozen', 'bash', '-euo', 'pipefail', '-c']
set positional-arguments

pnpm := "pnpm exec"

# List available recipes
default:
    @just --list

# ------------------------------------------------------------------------------
# Setup
# ------------------------------------------------------------------------------

# Install all dependencies (Python + Node.js)
install: install-node install-python

# Install only Node.js dependencies
install-node:
    #!/usr/bin/env bash
    pnpm install --frozen-lockfile

# Install only Python dependencies
install-python:
    #!/usr/bin/env bash
    uv sync --frozen

# ------------------------------------------------------------------------------
# Linting
# ------------------------------------------------------------------------------

# Run all linters
lint: lint-spelling lint-yaml lint-shell lint-json lint-docs

# Check spelling
lint-spelling:
    codespell

# Lint YAML files
lint-yaml:
    yamllint --strict .

# Lint shell scripts
lint-shell:
    #!/usr/bin/env bash
    shellcheck src/*/install.sh test/*/*.sh

# Lint JSON files
lint-json:
    {{pnpm}} biome check --files-ignore-unknown=true .

# Lint documentation
lint-docs: lint-markdown lint-prose

# Lint Markdown files
lint-markdown *args:
    {{pnpm}} markdownlint-cli2 {{ if args == "" { '"**/*.md"' } else { args } }}

# Lint prose in Markdown files
lint-prose *args:
    vale {{ if args == "" { "src/**/*.md README.md" } else { args } }}

# Format code
format:
    codespell -w
    {{pnpm}} biome format --write .

# Fix code issues
fix:
    {{pnpm}} biome format --write .
    {{pnpm}} biome check --write .

# Sync Vale styles and dictionaries
vale-sync:
    vale sync

# ------------------------------------------------------------------------------
# Pre-commit
# ------------------------------------------------------------------------------

# Run pre-commit hooks on changed files
prek:
    prek

# Run pre-commit hooks on all files
prek-all:
    prek run --all-files

# Install pre-commit hooks
prek-install:
    prek install

# ------------------------------------------------------------------------------
# Testing
# ------------------------------------------------------------------------------

# Test a specific feature
test feature *args:
    #!/usr/bin/env bash
    devcontainer features test \
        --features "{{ feature }}" \
        --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
        "$@"

# Test all features
test-all *args:
    #!/usr/bin/env bash
    devcontainer features test \
        --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
        "$@"

# Validate feature metadata
validate:
    #!/usr/bin/env bash
    for feature in src/*/; do
        echo "Validating ${feature}..."
        if [[ ! -f "${feature}devcontainer-feature.json" ]]; then
            echo "ERROR: Missing devcontainer-feature.json in ${feature}"
            exit 1
        fi
        if [[ ! -f "${feature}install.sh" ]]; then
            echo "ERROR: Missing install.sh in ${feature}"
            exit 1
        fi
        # Validate JSON
        jq empty "${feature}devcontainer-feature.json"
    done
    echo "All features valid"

# ------------------------------------------------------------------------------
# Local Development
# ------------------------------------------------------------------------------

# Build a test container with a feature
build-test feature:
    #!/usr/bin/env bash
    tmp_dir=$(mktemp -d)
    cat > "${tmp_dir}/devcontainer.json" << EOF
    {
        "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
        "features": {
            "./src/{{ feature }}": {}
        }
    }
    EOF
    devcontainer build --workspace-folder "${tmp_dir}"
    rm -rf "${tmp_dir}"

# Run a shell in a test container with a feature
shell-test feature:
    #!/usr/bin/env bash
    tmp_dir=$(mktemp -d)
    cat > "${tmp_dir}/devcontainer.json" << EOF
    {
        "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
        "features": {
            "./src/{{ feature }}": {}
        }
    }
    EOF
    devcontainer up --workspace-folder "${tmp_dir}"
    devcontainer exec --workspace-folder "${tmp_dir}" bash
    rm -rf "${tmp_dir}"

# ------------------------------------------------------------------------------
# CI Helpers
# ------------------------------------------------------------------------------

# List all features
list-features:
    #!/usr/bin/env bash
    for feature in src/*/; do
        basename "${feature}"
    done

# Get feature version
feature-version feature:
    #!/usr/bin/env bash
    jq -r '.version' "src/{{ feature }}/devcontainer-feature.json"
