# Working Instructions

- Do only what is explicitly asked. No extra steps, refactors, or improvements beyond the request.
- Before acting, confirm the plan with the user.
- Wait for explicit go-ahead before proceeding.

## Teaching After Code Changes

After making any code changes, do NOT immediately commit, push, or create a PR.

Instead, follow these steps in order:

1. **Teach first** — Explain every file you changed, what you changed in it, and why. Use simple language as if teaching a beginner. For each change, explain:
   - What the file/code does
   - What specifically changed
   - Why it was necessary
   - How it connects to the bigger picture

2. **Ask to commit** — After the explanation, ask: "Shall I commit these changes?"

3. **Ask to push** — After committing, ask: "Shall I push to remote?"

4. **Ask to create PR** — After pushing, ask: "Shall I create a PR?"

Never combine these steps. Each one requires explicit approval before proceeding to the next.

## Django

- All views must be function-based views (FBV). Class-based views (CBV) are not allowed.

## Git Commit Convention

Commit messages must follow conventional commits format. Keep the statement short and simple.

| Prefix      | When to use                          |
|-------------|--------------------------------------|
| `feat:`     | new feature                          |
| `fix:`      | bug fix                              |
| `chore:`    | maintenance, config, tooling changes |
| `docs:`     | documentation only                   |
| `ci:`       | CI/CD pipeline changes               |
| `refactor:` | code change, no feature or fix       |
| `test:`     | adding or updating tests             |
| `style:`    | formatting, linting                  |

## Versioning Rules

Versioning is handled automatically by `python-semantic-release` on merge to `main`.

| Commit type  | Version bump          |
|--------------|-----------------------|
| `feat:`      | minor (0.1.0 → 0.2.0) |
| `fix:`       | patch (0.1.0 → 0.1.1) |
| `refactor:`  | patch (0.1.0 → 0.1.1) |
| `BREAKING CHANGE` | major (0.1.0 → 1.0.0) |
| `chore:`, `ci:`, `docs:`, `style:`, `test:` | no bump |

- No pre-releases or beta releases
- Only `feat:` and `fix:` trigger a version bump
- Changelog is auto-updated in `CHANGELOG.md`
