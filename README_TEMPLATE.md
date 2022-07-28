# Introduction

# Development

## Requirements and setup

- Python 3.10 (`pip3` must be available) with installed globally:
  - [Poetry](https://python-poetry.org) installed globally.
  - [pre-commit](https://pre-commit.com) installed globally.
- Linux/UNIX compatible system with `make` command.
- [Docker](https://www.docker.com/).

Then, to set everything up on macOS:
```sh
brew install python@3.10 pre-commit
pip3 install poetry
```

After that, you should activate the pre-commit hooks by running _once_:

```bash
pre-commit install
```

## Shell with project's dependencies

```bash
make shell
```

Then run the commands as you wish.

## Tests

Running tests:
```bash
make unit-test
```

Running test coverage:
```bash
make test
```

## Static type checker

```bash
make lint-mypy
```
