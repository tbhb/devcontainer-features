# chezmoi

Installs [chezmoi](https://www.chezmoi.io/), a dotfiles manager that helps you manage your dotfiles across many machines.

## Usage

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/chezmoi:1": {}
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of chezmoi to install |

## Examples

Install the latest version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/chezmoi:1": {}
  }
}
```

Install a specific version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/chezmoi:1": {
      "version": "2.69.4"
    }
  }
}
```
