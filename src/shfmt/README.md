# shfmt

Installs [shfmt](https://github.com/mvdan/sh), a shell parser, formatter, and interpreter.

## Usage

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/shfmt:1": {}
  }
}
```

## Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `version` | string | `latest` | Version of shfmt to install |

## Examples

Install the latest version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/shfmt:1": {}
  }
}
```

Install a specific version:

```json
{
  "features": {
    "ghcr.io/tbhb/devcontainer-features/shfmt:1": {
      "version": "3.12.0"
    }
  }
}
```
