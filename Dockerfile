# stage: baseline
FROM python:3.10.6-slim-bullseye AS base

ENV PIP_DEFAULT_TIMEOUT=100 \
  PIP_DISABLE_PIP_VERSION_CHECK=1 \
  PIP_NO_CACHE_DIR=1 \
  POETRY_NO_INTERACTION=1 \
  POETRY_VERSION=1.1.13 \
  POETRY_VIRTUALENVS_IN_PROJECT=true \
  PYSETUP_PATH="/opt/pysetup" \
  PYTHONFAULTHANDLER=1 \
  PYTHONHASHSEED=random \
  PYTHONUNBUFFERED=1 \
  VENV_PATH="/opt/pysetup/.venv" \
  DOCKERIZE_VERSION=v0.6.1
ENV PATH="$VENV_PATH/bin:$PATH"
WORKDIR $PYSETUP_PATH

RUN apt-get -y update && \
  apt-get install -y --no-install-recommends gcc libc6-dev wget \
  && wget https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
  && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
  && rm dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
  && apt-get clean

# stage: builder (creates the .venv from poetry)
FROM base AS builder
RUN pip install -U pip "poetry==$POETRY_VERSION"

COPY pyproject.toml poetry.lock ./
RUN poetry install --no-dev

COPY py_scaffolding ./py_scaffolding
RUN poetry build

# stage: production image
FROM base AS production

COPY --from=builder $PYSETUP_PATH $PYSETUP_PATH

ENTRYPOINT [""]
CMD []

# stage: testing
FROM base AS testing
COPY --from=builder $PYSETUP_PATH $PYSETUP_PATH

RUN apt-get update && apt-get -y install --no-install-recommends make && rm -rf /var/lib/apt/lists/*
RUN pip install -U pip "poetry==$POETRY_VERSION"
RUN poetry install

COPY tests/ tests/
COPY Makefile Makefile

ENTRYPOINT [""]
CMD []

# stage: migrations
FROM base as migrations
COPY --from=builder $PYSETUP_PATH $PYSETUP_PATH

RUN apt-get -y update \
  && apt-get install -y --no-install-recommends postgresql-client \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

COPY migrations/ migrations/
COPY alembic.ini alembic.ini

ENTRYPOINT [""]
CMD []
