#!/bin/bash

# MkDocs Documentation Server Script
# This script starts the MkDocs development server

echo "🚀 Starting MkDocs documentation server..."
echo "📚 Documentation will be available at: http://127.0.0.1:8000"
echo "🔄 Server will auto-reload when files are modified"
echo ""
echo "Press Ctrl+C to stop the server"
echo "----------------------------------------"

# Start MkDocs development server
mkdocs serve --dev-addr=127.0.0.1:8000

echo ""
echo "📚 Documentation server stopped"
