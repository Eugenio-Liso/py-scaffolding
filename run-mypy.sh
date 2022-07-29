#!/usr/bin/env bash

# A script for running mypy,
# with all its dependencies installed.

set -o errexit

# Change directory to the project root directory.
cd "$(dirname "$0")"

# Install the dependencies into the mypy env.
# Note that this can take seconds to run.
echo "Installing dependencies for MyPy..."
poetry install

poetry run mypy .
