# ts-react — TypeScript + React frontend

Tune OpenCode untuk proyek TypeScript/React (Vite atau Next) berbasis `npm`.

**Pemisahan ini otomatis:**

| Command | Policy |
|---|---|
| `npm test` / `npm run typecheck` / `npm run lint` / `npm run build` | allow |
| `git *` | allow |
| `npm run dev` | ask |
| `npm install` / `npm add` | ask |
| `npm publish` | deny |

**Dikemas bersama:**

- `AGENTS.md` — konvensi komponen, hooks, testing, rules for agents
- `react-reviewer` agent — review ketat untuk diff frontend
- `/component` command — scaffold komponen baru

**Cara pakai:**

```bash
blueprint.sh init ts-react
# di dalam repo proyek React kamu
```

Tambahkan `--root` jika ingin `AGENTS.md` juga ditulis di root proyek.