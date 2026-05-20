FROM python:3.13-slim

WORKDIR /app

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

COPY pyproject.toml uv.lock ./

RUN uv sync --no-dev

COPY . .

EXPOSE 8000

CMD ["sh", "-c", "uv run python manage.py migrate && uv run gunicorn infrapilot.wsgi:application --bind 0.0.0.0:8000"]
