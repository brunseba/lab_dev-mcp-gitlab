#!/bin/bash

# MkDocs Documentation Server Script
# This script starts the MkDocs development server

# Change to project root directory
cd "$(dirname "$0")/.."

echo "🚀 Starting MkDocs documentation server..."
echo "📚 Documentation will be available at: http://127.0.0.1:8000"
echo "🔄 Server will auto-reload when files are modified"
echo ""
echo "Press Ctrl+C to stop the server"
echo "----------------------------------------"

# Check if virtual environment exists and activate it
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Creating one..."
    python3 -m venv venv
    source venv/bin/activate
    pip install mkdocs-material mkdocs-git-revision-date-plugin mkdocs-git-authors-plugin
else
    source venv/bin/activate
fi

# Start MkDocs development server
mkdocs serve --dev-addr=127.0.0.1:8000

echo ""
echo "📚 Documentation server stopped"
