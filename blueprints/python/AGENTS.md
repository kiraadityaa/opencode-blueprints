# AGENTS.md — Python project

## Stack

- Python 3. Prefer `uv` for environment/deps when present (check `uv.lock`/`pyproject.toml`), else `pip` + `venv`.
- Dependencies in `pyproject.toml`; avoid ad-hoc `requirements.txt` unless the project already uses one.

## Commands

- `uv run pytest` (or `.venv/bin/python -m pytest`) — run tests
- `uv run ruff check .` — lint
- `uv run ruff format .` — format
- `uv run mypy .` — type check (if configured)
- `uvicorn ... --reload` / `streamlit run ...` — dev servers (project-specific)

## Conventions

- Use type hints on all public functions; prefer `dataclasses`/TypedDict over loose dicts.
- One module per concern; keep functions small and pure where possible.
- Name tests `test_*.py` next to the code; cover success and error paths.
- Use exceptions for control flow only when it mirrors the domain; never swallow exceptions silently.
- Prefer `pathlib.Path` over string paths; avoid `os.path` unless required.
- Load configuration (secrets, flags) from environment via a small config module — never hardcode or log secrets.
- Respect an existing `.python-version` and virtualenv; do not pollute global site-packages.

## Rules for agents

- Read `pyproject.toml` first to learn test/lint tooling and supported Python versions.
- Before committing, run the test suite and `ruff check .`.
- Do not install packages into the system Python or add dependencies without asking.
- If `uv` is available, use it instead of bare `pip`.