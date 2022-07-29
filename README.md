# py-scaffolding
My custom Python project scaffolding repository.
https://github.com/lordgordon/py-scaffolding

![pr-validation](https://github.com/lordgordon/py-scaffolding/workflows/pr-validation/badge.svg?branch=main)

## Requirements and setup

- Python 3.10 (`pip3` must be available) with installed globally:
  - [Poetry](https://python-poetry.org) installed globally.
  - [pre-commit](https://pre-commit.com) installed globally.
- Linux/UNIX compatible system with `make` command.
- [Docker](https://www.docker.com/).

Then, to set everything up on macOS:
```sh
brew install python@3.10 pre-commit poetry pylint
pre-commit install
make
```

### Configure new project

```bash
# Creates a new folder
poetry new <project-name>

# Copy the following files:
# .pre-commit-config.yaml
# Makefile
# mypy.ini
# .dockerignore
# .coveragerc
# run-mypy.sh

# Then run
pre-commit install

# Change pytest version to ^7.1 and run
poetry update

# Remove README.rst and create a new file README.md with the template you find in README_TEMPLATE.md. Fill the Introduction paragraph

# Then create the project on your favourite Git platform and push!
```

### Configure PyCharm

Open the project and let it do all the magic!

## Release and Changelog

Version bump and changelog update:
```sh
# PATCH
poetry run cz bump --increment PATCH -ch --dry-run
# MINOR
poetry run cz bump --increment MINOR -ch --dry-run
# MAJOR
poetry run cz bump --increment MAJOR -ch --dry-run
```

If OK, run again without `--dry-run`. For full details see
https://commitizen-tools.github.io/commitizen/bump/

## Commands

The main command that run everything (full clean excluded):
```sh
make
```

`make help` to the rescue in case of doubts.
