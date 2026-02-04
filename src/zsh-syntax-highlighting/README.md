# zsh-syntax-highlighting

Installs [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), a syntax highlighting plugin for zsh inspired by the Fish shell.

## Usage

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/zsh-syntax-highlighting:1": {}
  }
}
```

## Configuration

After installation, the plugin sources automatically in your `.zshrc`. The plugin highlights commands as you type:

- Valid commands display in green
- Invalid commands display in red
- Strings, options, and paths display with distinct highlighting
