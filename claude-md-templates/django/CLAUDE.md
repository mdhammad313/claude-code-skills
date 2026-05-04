# CLAUDE.md

## Project
<!-- One sentence: what this project does and who it's for. -->
[Describe the project here]

## Stack
- Python [version]
- Django [version]
- Django REST Framework
- [DB: PostgreSQL / SQLite / other]
- [Task queue: Celery / other]
- [Cache: Redis / Memcached / other]

## Commands
```bash
# Activate virtual environment
source venv/bin/activate       # macOS/Linux
venv\Scripts\activate          # Windows

# Install dependencies
pip install -r requirements.txt

# Dev server
python manage.py runserver

# Shell
python manage.py shell

# Tests
python manage.py test
python manage.py test apps.users.tests.test_views   # single module

# Lint / format
ruff check .
ruff format .

# Migrations
python manage.py makemigrations   # create migration files
python manage.py migrate          # apply migrations
python manage.py showmigrations   # check status

# Create superuser
python manage.py createsuperuser
```

## Architecture
```
config/               — project settings, urls, wsgi/asgi
  settings/
    base.py           — shared settings
    local.py          — local dev overrides
    production.py     — production overrides
apps/                 — Django apps (one per domain concept)
  users/
    models.py
    views.py
    serializers.py
    urls.py
    tests/
  [other apps]/
requirements/
  base.txt            — shared dependencies
  local.txt           — dev dependencies
  production.txt      — production dependencies
```

## App conventions
- One Django app per domain concept — keep apps small and focused
- Fat models, thin views — business logic lives in models or a `services.py` layer, not views
- Never put business logic in serializers — serializers only handle data shape and validation
- Use `get_object_or_404` in views, not bare `Model.objects.get()`

## Django REST Framework
- Use `ModelSerializer` for CRUD; write custom `Serializer` only when the shape diverges meaningfully from the model
- Always version APIs: `api/v1/...`
- Use `IsAuthenticated` as the default permission class in settings; override per-view only when needed
- Return `400` for validation errors, `404` for missing objects, `403` for permission errors — never `200` with an error body

## Models
- Always define `__str__` on every model
- Use `verbose_name` and `verbose_name_plural` on `Meta`
- Add `created_at` and `updated_at` fields to every model that tracks time
- Never use `null=True` on string fields — use `blank=True` and default to `""`

## Migrations
- Never auto-apply migrations — always show the command and let the user run it
- Never edit a migration that has already been applied in any environment
- Always run `makemigrations` and check the diff before applying
- Name significant migrations: `python manage.py makemigrations --name describe_the_change`

## Tests
- Use Django's `TestCase` for DB tests, `SimpleTestCase` for pure logic
- Use `APIClient` from DRF for API endpoint tests
- Never mock the database — use the test database
- Aim for one test file per view file

## Environment
- Settings are split by environment — use `DJANGO_SETTINGS_MODULE` to select
- Never commit `.env` or any file with secrets
- Use `python-decouple` or `django-environ` to load env vars

## Never do
- Never use `DEBUG=True` in production
- Never call `eval()` or `exec()` on user input
- Never use raw SQL with string formatting — use parameterized queries or the ORM
- Never run `migrate` in production without a backup

## Git
- Branch format: `type/short-description`
- Commit format: `type: description`
- Types: `feat` `fix` `refactor` `test` `docs` `chore`
