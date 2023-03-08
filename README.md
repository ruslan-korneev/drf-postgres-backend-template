# Django REST with Postgres Template

# Installation and Running
## Using docker
```bash
cat env_sample > .env  # change variables values if you need
docker compose up -d
```

## Without docker for development
```zsh
python -m venv .venv
. .venv/bin/activate
cat env_sample > .env  # change variables values if you need, e.g. DJANGO_SETTINGS_MODULE=src.settings.local

poetry install
pre-commit install
dj migrate
dj runserver
```

## Project's Structure
```
docker-compose.yaml
Dockerfile
entrypoint.sh
env_sample
poetry.lock
pyproject.toml
README.md
src
├── manage.py
├── urls.py
└── wsgi.py
├── settings
│   ├── __init__.py
│   ├── local.py
│   ├── spectacular.py
│   └── test.py
├── apps
│   ├── __init__.py
│   ├── your_app
│   │   ├── __init__.py
│   │   ├── models.py
│   └── └── ...
└── conftest.py
```

## Django Settings
basic django settings located at `src/settings/__init__.py`

## Your Applications
you can collect you application modules inside src.apps package,
to include app:
```python
INSTALLED_APPS = [
    # django's
    ...,
    # third party
    ...,
    # your apps
    "src.apps.my_app", # if app name is users - then use here "src.apps.users"
]
```

# Continuous Integration
1. Tests: replace `echo` command with arguments to `pytest`. Pytest's settings are in [pyproject.toml](pyproject.toml)  
