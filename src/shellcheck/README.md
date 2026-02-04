# shellcheck

Installs [ShellCheck](https://github.com/koalaman/shellcheck), a static analysis tool for shell scripts.

## Usage

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/shellcheck:1": {}
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of ShellCheck to install |

## Examples

Install the latest version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/shellcheck:1": {}
  }
}
```

Install a specific version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/shellcheck:1": {
      "version": "0.10.0"
    }
  }
}
```
