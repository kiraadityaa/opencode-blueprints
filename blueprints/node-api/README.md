# node-api — Node.js HTTP API

Tune OpenCode untuk proyek API Node.js (Express / Fastify) berbasis `npm`.

**Pemisahan ini otomatis:**

| Command | Policy |
|---|---|
| `npm test` / `npm run typecheck` / `npm run lint` / `npm run build` | allow |
| `git *` | allow |
| `npm run dev` / `npm start` | ask |
| `npm install` / `npm add` | ask |
| `npm publish` | deny |

**Dikemas bersama:**

- `AGENTS.md` — konvensi route, zod validation, error handling, testing
- `api-reviewer` agent — review ketat untuk kode backend/API
- `/endpoint` command — scaffold endpoint baru

**Cara pakai:**

```bash
blueprint.sh init node-api
# di dalam repo proyek API kamu
```

Tambahkan `--root` jika ingin `AGENTS.md` juga ditulis di root proyek.