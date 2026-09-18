# AGENTS.md — TypeScript / React project

## Stack

- TypeScript (strict), React, Node.js. Package manager: `npm`.
- Build: Vite (or framework configured in this repo — check `package.json` scripts).
- Tests: Vitest. Linting: ESLint (see `eslint.config.*`).

## Commands

- `npm run dev` — start dev server
- `npm run build` — typecheck + production build
- `npm run lint` — lint
- `npm test` — run unit tests
- `npm run typecheck` — TypeScript only

## Conventions

- Follow existing component/hook/file structure. New shared UI goes in `src/components/`.
- Prefer `satisfies` over `as`; avoid `any`. No non-null assertions without justification.
- Conditionals prefer discriminated unions over boolean flags.
- Components are typed with `props` interfaces; export the type alongside the component.
- Keep components small and presentational; lift state and side effects to hooks.
- Add tests alongside non-trivial logic; keep them behaviour-focused (Vitest, `testing-library`).
- Update `AGENTS.md` when commands or conventions change.

## Rules for agents

- Verify assumptions by reading code; never invent APIs.
- Before committing, run lint, typecheck, and the relevant tests.
- Keep dependency changes to a minimum and explain them.
- Do not run `npm install` or `npm add` without asking.