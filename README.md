# Dev container features

Custom [Dev Container Features](https://containers.dev/implementors/features/) for development environments.

## Usage

Reference features in your `devcontainer.json`:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/<feature>:1": {}
  }
}
```

## Available features

| Feature | Description |
|---------|-------------|
| [just](src/just) | Command runner for project-specific tasks |
| [shellcheck](src/shellcheck) | Static analysis tool for shell scripts |
| [shfmt](src/shfmt) | Shell parser, formatter, and interpreter |
| [tmux](src/tmux) | Terminal multiplexer |
| [zsh-autosuggestions](src/zsh-autosuggestions) | autosuggestions for zsh (Fish shell-style) |
| [zsh-syntax-highlighting](src/zsh-syntax-highlighting) | Syntax highlighting for zsh (Fish shell-style) |

## Development

### Prerequisites

- [devcontainer CLI](https://github.com/devcontainers/cli)
- [just](https://just.systems/)
- [uv](https://docs.astral.sh/uv/)
- Docker
- shellcheck

### Commands

```bash
# List available commands
just

# Install Python dependencies
just install

# Run all linters
just lint

# Test a specific feature
just test <feature>

# Test all features
just test-all

# Validate feature metadata
just validate

# Build a test container with a feature
just build-test <feature>

# Run a shell in a test container
just shell-test <feature>
```

### Creating a feature

1. Create a new directory under `src/<feature-name>/`
2. Add `devcontainer-feature.json` with metadata
3. Add `install.sh` with installation logic
4. Add tests under `test/<feature-name>/`

See the [Dev Container Features specification](https://containers.dev/implementors/features/) for details.

## License

MIT
