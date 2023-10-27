#!/bin/bash

# Check if pipenv is installed
if ! command -v pipenv &> /dev/null
then
    echo "pipenv could not be found. Please install pipenv and try again."
    exit 1
fi

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Set the path to the Python script based on the directory of the current script
SCRIPT_PATH="$DIR/scripts/python/homControl.py"

# Navigate to the directory containing the Python script
cd "$(dirname "$SCRIPT_PATH")"

# Install the dependencies using pipenv
pipenv install

# Run the Python script with pipenv
if [ -f "$SCRIPT_PATH" ]; then
    pipenv run python "$(basename "$SCRIPT_PATH")"
else
    echo "Error: Python script not found at $SCRIPT_PATH"
    exit 1
fi
