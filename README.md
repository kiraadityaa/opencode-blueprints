<div align="center">

# ⌘ opencode-blueprints

**Per-project OpenCode setups — drop-in `.opencode/` config, one per stack.**

One command, and your OpenCode gets a stack-tuned config for the project you're working in — permissions, AGENTS.md, agents, and commands, all inside `.opencode/`.

[![Shellcheck](https://img.shields.io/github/actions/workflow/status/kiraadityaa/opencode-blueprints/ci.yml?branch=main&label=CI&logo=github)](https://github.com/kiraadityaa/opencode-blueprints/actions)
[![License](https://img.shields.io/github/license/kiraadityaa/opencode-blueprints?color=blue)](LICENSE)
[![Release](https://img.shields.io/github/v/release/kiraadityaa/opencode-blueprints?logo=github)](https://github.com/kiraadityaa/opencode-blueprints/releases)
[![Repo](https://img.shields.io/badge/opencode-setup--opencode-3b3b3b?logo)](https://github.com/kiraadityaa/setup-opencode)

</div>

---

## What is this?

OpenCode reads **global** config from `~/.config/opencode/` and **project** config from `.opencode/` next to your project. Global setup ([setup-opencode](https://github.com/kiraadityaa/setup-opencode)) is perfect for *everywhere*. But different projects want different rules:

| | Global (`setup-opencode`) | Per-project (**this repo**) |
|---|---|---|
| Installs to | `~/.config/opencode/` | `.opencode/` inside your project |
| Scope | Every project on the machine | Just the repo you deploy it into |
| Best for | Machine-wide defaults, MCPs, skills | Stack-specific permissions, agents, commands |
| Example | sudo allow, git rules, memory MCP | `npm publish: deny` for a frontend, `uv` allow for Python |

**opencode-blueprints** gives you ready-made, stack-tuned project configs. Pick one, run one command, done.

## Available blueprints

| Blueprint | Stack | Applies |
|---|---|---|
| **ts-react** | TypeScript + React (Vite/Next) | npm test/build/lint/typecheck allow, dev/install ask, publish deny |
| **node-api** | Node.js API (Express/Fastify) | same as above + `npm start` ask |
| **python** | Python (uv/pip) + pytest/ruff/mypy | uv/pytest/ruff/mypy allow, pip install ask |

Each blueprint ships `opencode.json`, `AGENTS.md`, a stack **agent** (e.g. `react-reviewer`), and a stack **command** (e.g. `/component`).

## Quick start

Requires: `bash`, `curl` (for remote blueprints), git.

Clone and initialize — inside the repo of the project you want to configure:

```bash
git clone https://github.com/kiraadityaa/opencode-blueprints.git
cd opencode-blueprints && bash blueprint.sh init ts-react   # or: node-api, python
```

Or without cloning — the script fetches the blueprint catalog on first run:

```bash
cd /path/to/your-project
curl -fsSL https://github.com/kiraadityaa/opencode-blueprints/raw/main/blueprint.sh | bash -s init python
```

That's it. Deploy removes nothing on your machine — it only creates `.opencode/` inside the current project.

> **Positioning:** use `setup-opencode` for your machine-wide config, and **opencode-blueprints** per project. They compose — project rules apply on top of your global config.

## CLI reference

```
blueprint.sh list                 List available blueprints
blueprint.sh show <name>          Show details of a blueprint
blueprint.sh init <name>          Apply a blueprint into .opencode/ of the current project
blueprint.sh update               Refresh the blueprint catalog from GitHub
blueprint.sh --version            Print version and exit
blueprint.sh --help               Show this help
```

### `init` options

| Option | Description |
|---|---|
| `--dir <path>` | Target project directory (default: current dir) |
| `--root` | Also write `AGENTS.md` to the project root |
| `--no-agents` | Skip stack agents |
| `--no-commands` | Skip stack commands |
| `--force` | Overwrite existing `.opencode` (backs it up to `.opencode.bak.<ts>` first) |
| `--dry-run` | Preview actions without making changes |
| `--verbose` | Show every executed command |

### What `init` creates

```
your-project/
└── .opencode/
    ├── opencode.json     # project config: AGENTS.md + stack permissions
    ├── AGENTS.md         # stack conventions + rules for agents
    ├── agents/           # e.g. react-reviewer.md, api-reviewer.md
    └── commands/         # e.g. component.md, endpoint.md
```

`opencode.json` sets `"instructions": ["AGENTS.md"]` (resolved relative to `.opencode/`) so OpenCode loads the stack rules automatically.

## Adding a blueprint

Blueprints live in `blueprints/`. Each is a folder with:

```
blueprints/<name>/
├── blueprint.meta       # name, description, stack, effort, keywords, aliases
├── opencode.json        # valid JSON project config (validated in CI)
├── AGENTS.md            # stack conventions + rules for agents
├── agents/*.md          # optional stack agents
├── commands/*.md        # optional stack commands
└── README.md            # short human-readable description
```

Deploy this machine is safe-by-design:

- The script **never touches** your global `~/.config/opencode/`.
- It only writes inside the target project (`.opencode/`, plus root `AGENTS.md` only with `--root`).
- Existing `.opencode` is overwritten only with `--force`, after a timestamped backup.

## FAQ

<details>
<summary><b>How do I undo a blueprint?</b></summary>

```bash
rm -rf .opencode
```

Your global OpenCode config is untouched, so nothing else is affected.

</details>

<details>
<summary><b>What if `.opencode/opencode.json` already exists?</b></summary>

`init` asks before overwriting. With `--force` it backs the current folder up to `.opencode.bak.<timestamp>` and deploys fresh.

</details>

<details>
<summary><b>Does the permission block replace my global rules?</b></summary>

No. Project config extends the global one — OpenCode merges them. The blueprint only adds stack-tuned rules on top (e.g. `npm publish: deny`).

</details>

<details>
<summary><b>Can I use it without cloning?</b></summary>

Yes — the piped `curl … | bash -s init <name>` variant auto-downloads and caches the catalog to `~/.cache/opencode-blueprints/`. Run `update` to refresh it.

</details>

## Project structure

```
.
├── blueprint.sh          # the CLI (bash, zero deps)
├── blueprints/
│   ├── ts-react/         # TypeScript + React (Vite/Next)
│   ├── node-api/         # Node.js API (Express/Fastify)
│   └── python/           # Python (uv/pip)
├── VERSION               # current version (SemVer)
├── .github/workflows/    # CI: shellcheck + validation + init smoke test
└── LICENSE               # MIT
```

## Development

See [CONTRIBUTING.md](CONTRIBUTING.md). Every change to `blueprints/*` or `blueprint.sh` is validated in CI: `shellcheck` on the script, JSON validity of each `opencode.json`, and an end-to-end `init` smoke test.

## License

[MIT](LICENSE) © kazehaya aditya