# CLAUDE.md

## Project overview

Custom Dev Container Features for development environments, following the [Dev Container Features specification](https://containers.dev/implementors/features/). Features are published to `ghcr.io/tbhb/devcontainer-features`.

## Commands

Task runner: `just` (requires uv for Python dependencies)

```bash
just                    # List all commands
just install            # Install all dependencies (pnpm + uv)
just lint               # Run all linters (spelling, yaml, shell, json, docs)
just test <feature>     # Test a specific feature
just test-all           # Test all features
just validate           # Validate feature metadata (JSON + required files)
just build-test <feature>  # Build test container with feature
just shell-test <feature>  # Shell into test container
just prek               # Run pre-commit hooks on changed files
just format             # Auto-format code (codespell + biome)
just fix                # Fix code issues (biome)
```

Individual linters:

```bash
just lint-shell         # shellcheck on install.sh and test scripts
just lint-json          # biome check
just lint-yaml          # yamllint
just lint-spelling      # codespell
just lint-markdown      # markdownlint-cli2
just lint-prose         # vale
```

## Architecture

### Feature structure

Each feature lives in `src/<feature-name>/` with:

- `devcontainer-feature.json` - Metadata, options, and dependencies
- `install.sh` - Bash installation script
- `README.md` - Feature documentation

Tests live in `test/<feature-name>/` with:

- `test.sh` - Basic installation tests
- `version.sh` - Optional version-specific tests

### Feature metadata (devcontainer-feature.json)

```json
{
  "id": "feature-name",
  "version": "1.0.0",
  "name": "Feature Name",
  "description": "What it does",
  "documentationURL": "https://github.com/tbhb/devcontainer-features/tree/main/src/feature-name",
  "options": {
    "version": {
      "type": "string",
      "default": "latest",
      "description": "Version to install"
    }
  },
  "installsAfter": ["ghcr.io/devcontainers/features/common-utils"]
}
```

### Installation scripts (install.sh)

Pattern for install scripts:

1. Set `-e` for fail-fast
2. Read options from environment (`VERSION="${VERSION:-latest}"`)
3. Detect architecture (`uname -m`)
4. Download and install binary
5. Verify installation (`tool --version`)

### Test scripts (test.sh)

Pattern for tests:

1. Set `-e` for fail-fast
2. Verify tool is in PATH (`which tool`)
3. Check version output
4. Test basic features

## CI/CD

- `test.yaml` - Tests all features on push/PR against Ubuntu base image
- `release.yaml` - Auto-publishes to GHCR on push to main

## Code quality

Linting tools configured:

- `shellcheck` - Shell script analysis
- `biome` - JSON formatting and linting
- `yamllint` - YAML validation (strict mode)
- `codespell` - Spell checking
- `markdownlint-cli2` - Markdown linting
- `vale` - Prose linting (Google, write-good styles)

Pre-commit hooks via `prek` (run `just prek-install` to set up).
