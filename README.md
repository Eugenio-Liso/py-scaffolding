# py-scaffolding
My custom Python project scaffolding repository.
Inspired by https://github.com/lordgordon/py-scaffolding

## Requirements and setup

- Python 3.10 (`pip3` must be available) with installed globally:
  - [Poetry](https://python-poetry.org) installed globally.
  - [pre-commit](https://pre-commit.com) installed globally.
- Linux/UNIX compatible system with `make` command.
- [Docker](https://www.docker.com/).

Then, to set everything up on macOS:
```sh
brew install python@3.10 pre-commit poetry
pre-commit install
```

### Configure new project

```bash
# Creates a new folder
poetry new <project-name>

# Copy the following files:
- .pre-commit-config.yaml
- Makefile
- mypy.ini
- .gitignore
- .dockerignore
- .coveragerc
- run-pre-commit-command.sh
- pytest.ini

# Then create the project on your favourite Git platform and init the repository

# Then run
pre-commit install

# Change pytest version to ^7.1 and run
poetry update

# Remove README.rst and create a new file README.md with the template you find in README_TEMPLATE.md. Fill the Introduction paragraph
# Enjoy!
```

### Configure PyCharm/IntelliJ Idea

Open the project and let it do all the magic!

## Troubleshoot

### Pylint

If you get an error when running the pre-commit hook, spawn a `poetry shell` and run the command `pylint <module-name>`.
That should fix it (I do not know the reason yet).
