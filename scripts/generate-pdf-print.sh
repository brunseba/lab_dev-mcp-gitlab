#!/bin/bash

# Enhanced MkDocs PDF Generation Script using print-site plugin
# This script uses the mkdocs-print-site-plugin to generate a printable page
# and then converts it to PDF using a headless browser

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
pip install -q mkdocs-print-site-plugin || {
    print_error "Failed to install mkdocs-print-site-plugin"
    exit 1
}

# Build the documentation
print_status "Building documentation with print-site plugin..."
mkdocs build || {
    print_error "Failed to build documentation"
    exit 1
}

# Check if print page was generated
if [ ! -f "site/print_page/index.html" ]; then
    print_error "Print page not generated. Check mkdocs.yml configuration."
    exit 1
fi

# Check if Chrome/Chromium is available for PDF conversion
CHROME_PATH=""
if command -v google-chrome &> /dev/null; then
    CHROME_PATH="google-chrome"
elif command -v chromium &> /dev/null; then
    CHROME_PATH="chromium"
elif command -v chromium-browser &> /dev/null; then
    CHROME_PATH="chromium-browser"
elif [ -x "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" ]; then
    CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
else
    print_warning "Chrome/Chromium not found. Will attempt to use system default browser."
    print_warning "For best results, install Chrome or Chromium."
fi

# Generate PDF using Chrome headless mode
if [ -n "$CHROME_PATH" ]; then
    print_status "Converting print page to PDF using Chrome..."
    "$CHROME_PATH" \
        --headless \
        --disable-gpu \
        --no-sandbox \
        --disable-dev-shm-usage \
        --print-to-pdf="documentation-print.pdf" \
        --print-to-pdf-no-header \
        --run-all-compositor-stages-before-draw \
        --virtual-time-budget=30000 \
        "file://$(pwd)/site/print_page/index.html" || {
        print_error "Failed to generate PDF with Chrome"
        exit 1
    }
    
    print_success "PDF generated successfully: documentation-print.pdf"
    ls -lh documentation-print.pdf
else
    print_warning "Chrome not available. Print page generated at: site/print_page/index.html"
    print_warning "You can manually open this in a browser and print to PDF."
fi

# Serve the docs to check the print page
print_status "You can check the print page by running:"
print_status "mkdocs serve"
print_status "Then visit: http://127.0.0.1:8000/print_page/"

print_success "Process completed!"
