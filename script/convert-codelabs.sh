#!/bin/bash
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ -d "/tmp/codelabs-source" ]; then
    IS_DOCKER=true
else
    IS_DOCKER=false
fi

DEFAULT_SOURCE_DIR="codelabs"
DEFAULT_OUTPUT_DIR="site/codelabs"

if [ "$IS_DOCKER" = false ]; then
    if [ -f ".env" ]; then
        echo -e "${BLUE}Reading configuration from .env${NC}"
        
        if grep -q "^CODELAB_SOURCE_DIR=" .env; then
            ENV_SOURCE=$(grep "^CODELAB_SOURCE_DIR=" .env | cut -d'=' -f2 | tr -d '\r' | tr -d '"' | tr -d "'")
            if [ -n "$ENV_SOURCE" ]; then
                DEFAULT_SOURCE_DIR="$ENV_SOURCE"
                echo -e "${GREEN}  ✓ CODELAB_SOURCE_DIR: $DEFAULT_SOURCE_DIR${NC}"
            fi
        fi
        
        if grep -q "^CODELAB_OUTPUT_DIR=" .env; then
            ENV_OUTPUT=$(grep "^CODELAB_OUTPUT_DIR=" .env | cut -d'=' -f2 | tr -d '\r' | tr -d '"' | tr -d "'")
            if [ -n "$ENV_OUTPUT" ]; then
                DEFAULT_OUTPUT_DIR="$ENV_OUTPUT"
                echo -e "${GREEN}  ✓ CODELAB_OUTPUT_DIR: $DEFAULT_OUTPUT_DIR${NC}"
            fi
        fi
        echo ""
    fi
fi

if [ "$IS_DOCKER" = true ]; then
    SOURCE_DIR="/tmp/codelabs-source"
    OUTPUT_DIR="./codelabs"
else
    SOURCE_DIR="${1:-$DEFAULT_SOURCE_DIR}"
    OUTPUT_DIR="${2:-$DEFAULT_OUTPUT_DIR}"
fi

echo -e "${GREEN}=== Codelab Conversion ===${NC}"
echo "Source: $SOURCE_DIR"
echo "Output: $OUTPUT_DIR"
echo ""

if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${RED}ERROR: Source directory not found: $SOURCE_DIR${NC}"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

MD_FILES=$(find "$SOURCE_DIR" -name "*.md" -type f 2>/dev/null || echo "")
if [ -z "$MD_FILES" ]; then
    MD_COUNT=0
else
    MD_COUNT=$(echo "$MD_FILES" | wc -l)
fi

if [ "$MD_COUNT" -eq 0 ]; then
    echo -e "${YELLOW}WARNING: No markdown files found in $SOURCE_DIR${NC}"
    exit 0
fi

echo -e "${GREEN}Found $MD_COUNT markdown file(s)${NC}"
echo ""

SUCCESS=0
FAILED=0

while IFS= read -r md_file; do
    FILENAME=$(basename "$md_file")
    echo -e "Converting: ${FILENAME}"
    
    if claat export -o "$OUTPUT_DIR" "$md_file" > /dev/null 2>&1; then
        SUCCESS=$((SUCCESS + 1))
        echo -e "  ${GREEN}✓ Success${NC}"
    else
        FAILED=$((FAILED + 1))
        echo -e "  ${RED}✗ Failed${NC}"
    fi
done <<< "$MD_FILES"

echo ""
echo -e "${GREEN}Conversion completed${NC}"
echo "  Total:   $MD_COUNT"
echo "  Success: $SUCCESS"
echo "  Failed:  $FAILED"
echo ""

if [ -d "$OUTPUT_DIR" ]; then
    echo "Output directory contents:"
    ls -lh "$OUTPUT_DIR" | tail -n +2 || echo "  (empty)"
fi

if [ "$IS_DOCKER" = true ]; then
    rm -rf "$SOURCE_DIR"
fi

echo ""
echo -e "${GREEN}Done!${NC}"
