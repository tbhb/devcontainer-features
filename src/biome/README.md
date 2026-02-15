# Biome (biome)

Installs [Biome](https://biomejs.dev/), a fast formatter and linter for JavaScript, TypeScript, JSON, and more.

## Example usage

```json
"features": {
    "ghcr.io/tbhb/devcontainer-features/biome:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|------------|-------------|------|---------------|
| version | Version of Biome to install ('2.3.14' or 'latest') | string | latest |

## Supported architectures

- x86_64 (amd64)
- aarch64/arm64

This feature supports both standard Linux and Alpine variants.

## Notes

- Downloads the standalone binary directly from GitHub releases
- Does not require Node.js
- Set `GITHUB_TOKEN` environment variable to avoid GitHub API rate limits
