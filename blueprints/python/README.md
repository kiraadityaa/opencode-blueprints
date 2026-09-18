# python — Python project

Tune OpenCode untuk proyek Python (`uv`/`pip`) dengan `pytest` + `ruff` + `mypy`.

**Pemisahan ini otomatis:**

| Command | Policy |
|---|---|
| `uv *` / `uvx *` | allow |
| `pytest*` / `python3 -m pytest*` | allow |
| `ruff *` / `mypy *` | allow |
| `.venv/bin/python*` / `source .venv/bin/activate*` | allow |
| `git *` | allow |
| `pip install*` | ask |

**Dikemas bersama:**

- `AGENTS.md` — konvensi tipe, struktur modul, testing, rules for agents
- `python-reviewer` agent — review ketat untuk kode Python
- `/pytest` command — jalankan suite + lint + type check

**Cara pakai:**

```bash
blueprint.sh init python
# di dalam repo proyek Python kamu
```

Tambahkan `--root` jika ingin `AGENTS.md` juga ditulis di root proyek.