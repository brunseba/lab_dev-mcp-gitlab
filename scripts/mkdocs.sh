#!/bin/bash

# Script to run MkDocs commands with the virtual environment
# Usage: ./scripts/mkdocs.sh [command]

# Change to project root directory
cd "$(dirname "$0")/.."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Creating one..."
    python3 -m venv venv
    source venv/bin/activate
    pip install mkdocs-material mkdocs-git-revision-date-plugin mkdocs-git-authors-plugin
else
    source venv/bin/activate
fi

# Run the mkdocs command with all passed arguments
mkdocs "$@"
