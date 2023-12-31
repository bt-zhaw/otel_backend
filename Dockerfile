FROM python:3.11-slim

WORKDIR /usr/src/app

RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*

RUN curl -sSL https://install.python-poetry.org | python3 -

ENV PATH="${PATH}:/root/.local/bin"

RUN poetry config virtualenvs.create false

COPY pyproject.toml poetry.lock* ./

RUN poetry install --no-interaction --no-ansi --no-dev

COPY . .

RUN useradd -m appuser
USER appuser

EXPOSE 8000

CMD ["uvicorn", "otel_backend.app:app", "--host", "0.0.0.0", "--port", "8000"]
