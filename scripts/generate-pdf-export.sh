#!/bin/bash

# Enhanced MkDocs PDF Generation Script using mkdocs-pdf-export-plugin
# This script uses the mkdocs-pdf-export-plugin to generate a PDF
# with better Mermaid diagram support using WeasyPrint

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_status "📄 Generating PDF documentation with mkdocs-pdf-export-plugin..."
print_status "🔄 This may take a few minutes..."

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    print_error "Virtual environment not found. Please run 'python -m venv venv' first."
    exit 1
fi

# Activate virtual environment
print_status "Activating virtual environment..."
source venv/bin/activate

# Install required dependencies if not present
print_status "Checking dependencies..."
pip install -q mkdocs-pdf-export-plugin || {
    print_error "Failed to install mkdocs-pdf-export-plugin"
    exit 1
}

# Set environment variable to enable PDF export
export ENABLE_PDF_EXPORT=1

print_status "🚀 Starting PDF generation with pdf-export plugin..."

# Build the documentation with PDF export
mkdocs build || {
    print_error "Failed to build documentation with PDF export"
    exit 1
}

# Check if PDF was generated
if [ -f "site/documentation-export.pdf" ]; then
    print_success "PDF generated successfully!"
    cp site/documentation-export.pdf documentation-export.pdf
    ls -lh documentation-export.pdf
    print_status "PDF saved as: documentation-export.pdf"
else
    print_error "PDF file not found. Check the build process above for errors."
    exit 1
fi

print_status "✨ PDF generation completed!"
print_success "Process completed!"
