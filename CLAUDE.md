# Working Instructions

- Do only what is explicitly asked. No extra steps, refactors, or improvements beyond the request.
- Before acting, confirm the plan with the user.
- Wait for explicit go-ahead before proceeding.

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
| `BREAKING CHANGE` | major (0.1.0 → 1.0.0) |
| `chore:`, `ci:`, `docs:`, `style:`, `test:`, `refactor:` | no bump |

- No pre-releases or beta releases
- Only `feat:` and `fix:` trigger a version bump
- Changelog is auto-updated in `CHANGELOG.md`
