# Changelog

All notable changes to this project are documented here. Adheres to [Semantic Versioning](https://semver.org/) and [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

## [0.2.0] - 2026-09-18

### Added
- `detect` command: keyword-scan a directory to suggest a blueprint (supports `--json`)
- `test` command: validate blueprints locally (`test all` or `test <name>`)
- `--json` flag for `list` and `show` — machine-readable JSON output (banner suppressed)
- `--dir` hardening: symlinked `.opencode` is refused unless `--force` replaces it

### Fixed
- `init --dir` now resolves to physical path (canonical `pwd -P`) to prevent symlink escape

### Added

- Initial release:
  - CLI `blueprint.sh` with `list`, `show <name>`, `init <name>`, `update`, `--version`, `--help`.
  - `init` options: `--dir`, `--root`, `--no-agents`, `--no-commands`, `--force`, `--dry-run`, `--verbose`.
  - Blueprint catalog with 3 stacks: `ts-react`, `node-api`, `python`.
  - Each blueprint ships `opencode.json`, `AGENTS.md`, a stack agent, and a stack command.
  - Auto-download of the catalog to `~/.cache/opencode-blueprints/` when not found locally.
  - CI: shellcheck, blueprint validation, and an end-to-end `init` smoke test.