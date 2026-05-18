# Steps Performed

## 1. Initialized uv Project

```bash
uv init --python 3.13
```

- Created uv project named `infrapilot`
- Downloaded and set Python 3.13.9

---

## 2. Added Django Dependency

```bash
uv add django
```

- Installed Django 6.0.5 (latest)
- Also installed: asgiref 3.11.1, sqlparse 0.5.5
- Created `.venv` virtual environment and `uv.lock`

---

## 3. Created Django Project

```bash
uv run django-admin startproject infrapilot .
```

- Created Django project named `infrapilot` in the root directory
- Generated: `infrapilot/settings.py`, `infrapilot/urls.py`, `infrapilot/wsgi.py`, `infrapilot/asgi.py`, `manage.py`

---

## 4. Run the Development Server

```bash
uv run manage.py runserver
```

- Starts Django development server at `http://127.0.0.1:8000/`

---

## 5. Created Dashboard App

```bash
uv run manage.py startapp dashboard
```

- Created `dashboard` app
- Registered `dashboard` in `INSTALLED_APPS` inside `infrapilot/settings.py`

---

## 6. Ran Migrations

```bash
uv run manage.py migrate
```

- Applied all default Django migrations
- Sets up database tables required for auth, sessions, admin, etc.

---

## 7. Created Superuser

```bash
uv run manage.py createsuperuser
```

- Created an admin superuser (username, email, password entered interactively)
- Admin panel accessible at `http://127.0.0.1:8000/admin/`

---

## 8. Created Templates Folder and HTML Pages

- Created root-level `templates/dashboard/` folder
- Created `templates/dashboard/login.html` — login form with username/password fields and error display
- Created `templates/dashboard/dashboard.html` — welcome page showing logged-in username with a logout link
- Updated `TEMPLATES['DIRS']` in `infrapilot/settings.py` to `[BASE_DIR / 'templates']` so Django can find root-level templates

---

## 9. Created Views in dashboard/views.py

- `login_view` — handles GET (show form) and POST (authenticate user, redirect to dashboard or show error)
- `dashboard_view` — protected with `@login_required`, renders dashboard page
- `logout_view` — logs user out and redirects to login page
- All views are function-based (FBV)

---

## 10. Wired Up URLs

- Created `dashboard/urls.py` with three routes:
  - `/` → `login_view`
  - `/dashboard/` → `dashboard_view`
  - `/logout/` → `logout_view`
- Included `dashboard.urls` in `infrapilot/urls.py` at the root path

---

## 11. Styled Pages with Bootstrap

- Added Bootstrap 5.3.3 via CDN to both `login.html` and `dashboard.html`
- Login page — centered card layout with form inputs, error alert styling
- Dashboard page — dark navbar with username display and logout button

---

## 12. Created Custom 404 Page

- Created `templates/404.html` with a Bootstrap styled 404 page
- Django automatically uses this file when `DEBUG=False` and a user hits an unknown URL
- No extra code or URL configuration needed

---

## 13. Added Linting and Testing Tools

```bash
uv add --dev flake8 black isort pytest pytest-django
```

Installed:
- `flake8` — checks code style and syntax errors
- `black` — auto-formats code
- `isort` — sorts imports
- `pytest` + `pytest-django` — runs tests

Configuration added to `pyproject.toml`:
- `[tool.black]` — line length 120
- `[tool.isort]` — profile set to black for compatibility, line length 120
- `[tool.pytest.ini_options]` — points pytest to `infrapilot.settings`

Created `setup.cfg` for flake8 config (flake8 does not support `pyproject.toml` natively).

---

## 14. Created Tests

- Created `tests/` folder with `__init__.py` and `tests/test_views.py`
- Three tests written:
  - `test_login_page_loads` — checks login page returns 200
  - `test_dashboard_redirects_unauthenticated` — checks unauthenticated access to dashboard redirects (302)
  - `test_login_with_invalid_credentials` — checks invalid login shows error message

Run tests:

```bash
uv run pytest
```

---

## 15. Updated Line Length to 120

- Changed `line-length` from 88 to 120 in `pyproject.toml` for black and isort
- Changed `max-line-length` from 88 to 120 in `setup.cfg` for flake8

---

## 16. Checked In Code to Git

- Updated `.gitignore` to include `db.sqlite3` and `.pytest_cache`
- Staged all files with `git add .`
- Committed and pushed to remote repository
