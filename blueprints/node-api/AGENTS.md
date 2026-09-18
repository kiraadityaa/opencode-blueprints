# AGENTS.md — Node.js API project

## Stack

- Node.js, TypeScript (if configured). Package manager: `npm`.
- Framework: Express or Fastify (check `package.json` / entry file).
- Validation: zod schemas shared between routes and types.

## Commands

- `npm run dev` — start dev server with watch
- `npm start` — start production server
- `npm run build` — typecheck + build
- `npm test` — run tests
- `npm run lint` — lint

## Conventions

- One route module per resource; register it in the app entry point.
- Validate every request body, query, and params with zod before handlers.
- Handlers return typed responses; errors go through a central error handler — never swallow errors silently.
- Use async handlers consistently; convert sync errors to rejected promises.
- Log requests/responses at controllers, not deep inside business logic.
- Keep configuration (ports, secrets, flags) in typed config, read from environment.
- Never log secrets, tokens, or full auth headers.
- Add tests that hit routes over HTTP (supertest-style) for the happy path and error cases.

## Rules for agents

- Read the entry point and framework version before proposing middleware.
- Before committing, run lint, typecheck, and the relevant tests.
- Never start long-running servers or expose ports without asking.
- Keep dependency changes to a minimum and explain them.
- Do not run `npm install` or `npm add` without asking.