#!/usr/bin/env bash

# A script for running a command,
# with all its dependencies installed.

set -o errexit

# Change directory to the project root directory.
cd "$(dirname "$0")"

# Install the dependencies into the env.
# Note that this can take seconds to run.
echo "Installing dependencies..."
poetry install

poetry run "$@"
