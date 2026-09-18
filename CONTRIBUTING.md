# Contributing

Thanks for helping improve opencode-blueprints! Every contribution — a new blueprint, a bug fix, better docs — matters.

## Getting started

1. Fork the repo and clone your fork.
2. Create a branch: `git checkout -b feat/my-change`.
3. Make your changes, following the guidelines below.
4. Run the checks (below) locally if possible.
5. Commit with a [Conventional Commits](https://www.conventionalcommits.org/) message, push, and open a PR to `main`.

## What makes a good contribution

- **New blueprint** — a stack with clear, commonly agreed conventions that would benefit from tuned permissions. Each blueprint needs `blueprint.meta`, `opencode.json`, `AGENTS.md`, and a `README.md` (agents/commands optional).
- **Bug fix** — a clear description in the PR of the failure and the fix.
- **Docs** — README, per-blueprint README, or FAQ improvements.

## Blueprint conventions

`blueprints/<name>/` must contain:

- `blueprint.meta` — `name:`, `description:`, `stack:`, `effort:`, `keywords:`, `aliases:` (comma-separated).
- `opencode.json` — **valid JSON** (no JSONC comments; it is parsed by CI).
- `AGENTS.md` — stack conventions plus a `Rules for agents` section.
- `README.md` — short human-readable summary.
- Optional `agents/*.md`, `commands/*.md` with YAML frontmatter (`description`, `mode`, optional `permission`).

Rules:

- Default bash permission is `ask`; make only well-scoped commands (e.g. `npm test*`, `uv *`) `allow`, and add a compensating `deny` (e.g. `npm publish*`) where it makes sense.
- `opencode.json` uses `"instructions": ["AGENTS.md"]`.
- Keep `AGENTS.md` concise: commands, conventions, rules for agents.

## Checks

```bash
# shellcheck the CLI
shellcheck blueprint.sh

# run the built-in validator (meta + JSON + default permission + frontmatter)
bash blueprint.sh test all

# detect smoke — should suggest a blueprint
bash blueprint.sh detect .

# smoke test init (deploy + dry-run)
bash blueprint.sh init ts-react --dir "$(mktemp -d)" --force --dry-run
```

CI runs these automatically on every PR.

## Commit conventions

Follow Conventional Commits:

```
<type>(<scope>): <subject>
```

- `feat(blueprints): add go blueprint`
- `fix(init): respect --dir when .opencode exists`
- `docs(readme): clarify quick start`
- `chore: bump dev dependencies`

## Opening a PR

- Branch from the latest `main`.
- Reference any related issue.
- Include a short description of what changed and why.
- Keep the diff focused — one logical change per PR.

Thanks again! 🚀