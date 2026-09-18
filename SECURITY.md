# Security Policy

## Reporting a vulnerability

If you find a security issue, please **do not open a public issue**. Report it privately via GitHub's Security Advisories: create an advisory at <https://github.com/kiraadityaa/opencode-blueprints/security/advisories/new>, or email the maintainer directly through your GitHub profile.

You should receive an acknowledgement within 72 hours.

## What we care about

- The `blueprint.sh` installer must not execute untrusted content from remote sources beyond the pinned GitHub repo, and must not touch anything outside the target project directory (`~/.config/opencode/` is off-limits by design).
- `blueprint.sh` must never curl-pipe-and-execute third-party scripts; the only remote downloads are the blueprint catalog from this repository.
- Blueprint `permission` rules must not weaken global security posture (default `ask`, deny for publish, no credential exposure in generated files).

## Safe usage notes

- Review the `.opencode/opencode.json` permission block after `init` to make sure it matches your trust level.
- The piped `curl | bash -s init <name>` variant executes `blueprint.sh` directly — only use it from https://github.com/kiraadityaa/opencode-blueprints (as shown in the README), never from a mirrored copy you don't control.
- Blueprints are MIT-licensed templates, not security products. Permissions are convenience presets, not a sandbox.