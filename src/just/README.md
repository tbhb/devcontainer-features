# Just

Installs [just](https://github.com/casey/just), a handy way to save and run project-specific commands.

## Usage

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/just:1": {}
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of just to install |

## Examples

Install the latest version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/just:1": {}
  }
}
```

Install a specific version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/just:1": {
      "version": "1.23.0"
    }
  }
}
```
