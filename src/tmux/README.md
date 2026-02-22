# tmux

Installs [tmux](https://github.com/tmux/tmux), a terminal multiplexer.

## Usage

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/tmux:1": {}
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of tmux to install |

## Examples

Install the latest version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/tmux:1": {}
  }
}
```

Install a specific version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/tmux:1": {
      "version": "3.6a"
    }
  }
}
```
