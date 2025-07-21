#!/bin/bash

# Script to generate PDF documentation with Mermaid.js support
# Usage: ./scripts/generate-pdf.sh

# Change to project root directory
cd "$(dirname "$0")/.."

echo "📄 Generating PDF documentation..."
echo "🔄 This may take a few minutes..."
echo ""

# Check if virtual environment exists and activate it
if [ ! -d "venv" ]; then
    echo "Virtual environment not found. Creating one..."
    python3 -m venv venv
    source venv/bin/activate
    pip install mkdocs-material mkdocs-git-revision-date-plugin mkdocs-git-authors-plugin mkdocs-with-pdf mkdocs-mermaid2-plugin
else
    source venv/bin/activate
fi

# Set environment variable to enable PDF export
export ENABLE_PDF_EXPORT=1

# Create pdf directory if it doesn't exist
mkdir -p pdf

echo "🚀 Starting PDF generation..."

# Generate the PDF
mkdocs build

# Check if PDF was generated
if [ -f "site/pdf/document.pdf" ]; then
    # Copy PDF to project root for easy access
    cp "site/pdf/document.pdf" "documentation.pdf"
    echo "✅ PDF generated successfully!"
    echo "📍 Location: documentation.pdf"
    echo "📍 Also available at: site/pdf/document.pdf"
else
    echo "❌ PDF generation failed. Check the logs above."
    exit 1
fi

echo ""
echo "📊 PDF Statistics:"
ls -lh documentation.pdf | awk '{print "📦 Size: " $5}'
echo "📅 Generated: $(date)"
echo ""
echo "🎉 PDF documentation generation complete!"
