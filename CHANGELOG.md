# Changelog

All notable changes to this project are documented here. Adheres to [Semantic Versioning](https://semver.org/) and [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### Added

- Initial release:
  - CLI `blueprint.sh` with `list`, `show <name>`, `init <name>`, `update`, `--version`, `--help`.
  - `init` options: `--dir`, `--root`, `--no-agents`, `--no-commands`, `--force`, `--dry-run`, `--verbose`.
  - Blueprint catalog with 3 stacks: `ts-react`, `node-api`, `python`.
  - Each blueprint ships `opencode.json`, `AGENTS.md`, a stack agent, and a stack command.
  - Auto-download of the catalog to `~/.cache/opencode-blueprints/` when not found locally.
  - CI: shellcheck, blueprint validation, and an end-to-end `init` smoke test.