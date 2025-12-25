#!/bin/bash

# Script to extract mermaid blocks from documentation.md and generate PNG images
# Requires: @mermaid-js/mermaid-cli (install with: npm install -g @mermaid-js/mermaid-cli)

set -e

# Configuration
DOCS_FILE="documentation.md"
OUTPUT_DIR="images"
TEMP_DIR=$(mktemp -d)

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if documentation.md exists
if [ ! -f "$DOCS_FILE" ]; then
    echo -e "${RED}Error: $DOCS_FILE not found${NC}"
    exit 1
fi

# Check if mermaid CLI (mmdc) is installed
if ! command -v mmdc &> /dev/null; then
    echo -e "${RED}Error: mermaid-cli (mmdc) not found${NC}"
    echo "Install it with: npm install -g @mermaid-js/mermaid-cli"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"
echo -e "${GREEN}Created output directory: $OUTPUT_DIR${NC}"

# Extract mermaid blocks and generate images
echo -e "${YELLOW}Extracting mermaid diagrams from $DOCS_FILE...${NC}"

# Use awk to extract mermaid blocks from markdown file
# AWK processes the file line by line:
#   1. When it finds ```mermaid, it starts collecting lines
#   2. While inside a block, it accumulates all lines into a variable
#   3. When it finds the closing ```, it writes the accumulated content to a file
#   4. Each block is saved as mermaid_1.mmd, mermaid_2.mmd, etc.
awk '
/```mermaid/ {
    in_block = 1
    block_count++
    block = ""
    next
}
in_block && /```/ {
    in_block = 0
    print block > "'"$TEMP_DIR"'/mermaid_" block_count ".mmd"
    next
}
in_block {
    block = block $0 "\n"
}
' "$DOCS_FILE"

# Count extracted blocks
BLOCK_COUNT=$(ls -1 "$TEMP_DIR"/*.mmd 2>/dev/null | wc -l)

if [ "$BLOCK_COUNT" -eq 0 ]; then
    echo -e "${RED}No mermaid blocks found in $DOCS_FILE${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
fi

echo -e "${GREEN}Found $BLOCK_COUNT mermaid diagrams${NC}"

# Convert each mermaid file to PNG
# Sort files numerically to maintain correct order (1, 2, 3... not 1, 10, 2...)
counter=1
while IFS= read -r mmd_file; do
    output_file="$OUTPUT_DIR/img_${counter}.png"

    echo -e "${YELLOW}Generating: img_${counter}.png${NC}"

    # Generate PNG with mermaid CLI
    mmdc -i "$mmd_file" -o "$output_file" -b transparent 2>/dev/null

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Created: $output_file${NC}"
    else
        echo -e "${RED}✗ Failed to create: $output_file${NC}"
    fi

    ((counter++))
done < <(ls -1v "$TEMP_DIR"/*.mmd)

# Cleanup
rm -rf "$TEMP_DIR"

echo -e "${GREEN}Done! Generated $BLOCK_COUNT images in $OUTPUT_DIR/${NC}"
