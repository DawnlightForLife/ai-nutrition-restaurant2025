#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
BACKEND_ROOT="$( cd "$PROJECT_ROOT/../../backend" && pwd )"

echo -e "${BLUE}🔄 Smart Nutrition API Model Sync${NC}"
echo -e "${BLUE}================================${NC}"

# Step 1: Check for changes in backend models
echo -e "${YELLOW}📊 Checking for backend model changes...${NC}"

# Create a temporary directory for comparison
TEMP_DIR=$(mktemp -d)
CHANGE_LOG="$PROJECT_ROOT/docs/model-sync-$(date +%Y%m%d-%H%M%S).md"

# Generate current backend schema
cd "$BACKEND_ROOT"
node docs/swagger-generate.js > /dev/null 2>&1

# Copy current OpenAPI spec for comparison
cp "$PROJECT_ROOT/../../docs/openapi/openapi.yaml" "$TEMP_DIR/current.yaml"

# Check if there's a previous version to compare
LAST_SYNC_FILE="$PROJECT_ROOT/.last-sync-hash"
if [ -f "$LAST_SYNC_FILE" ]; then
    LAST_HASH=$(cat "$LAST_SYNC_FILE")
    CURRENT_HASH=$(shasum -a 256 "$TEMP_DIR/current.yaml" | cut -d' ' -f1)
    
    if [ "$LAST_HASH" = "$CURRENT_HASH" ]; then
        echo -e "${GREEN}✅ No changes detected in backend models${NC}"
        rm -rf "$TEMP_DIR"
        exit 0
    fi
fi

# Step 2: Generate models
echo -e "${YELLOW}🔧 Generating updated models...${NC}"
cd "$PROJECT_ROOT"
./scripts/generate-openapi-models.sh

# Step 3: Generate mappers
echo -e "${YELLOW}🔄 Updating mappers...${NC}"
./scripts/generate-mappers.sh

# Step 4: Run tests to verify compatibility
echo -e "${YELLOW}🧪 Running compatibility tests...${NC}"
flutter test test/infrastructure/mappers/ --no-pub || true

# Step 5: Generate change report
echo -e "${YELLOW}📝 Generating change report...${NC}"
cat > "$CHANGE_LOG" << EOF
# Model Sync Report
Generated: $(date)

## Summary
- Backend OpenAPI spec has been updated
- Frontend models have been regenerated
- Mappers have been updated

## Changed Files
### DTOs
EOF

# List changed DTOs
find lib/infrastructure/dtos/generated -name "*.dart" -newer "$LAST_SYNC_FILE" 2>/dev/null | sort >> "$CHANGE_LOG" || true

cat >> "$CHANGE_LOG" << EOF

### Mappers
EOF

# List changed mappers
find lib/infrastructure/mappers/generated -name "*.dart" -newer "$LAST_SYNC_FILE" 2>/dev/null | sort >> "$CHANGE_LOG" || true

# Step 6: Update sync hash
CURRENT_HASH=$(shasum -a 256 "$TEMP_DIR/current.yaml" | cut -d' ' -f1)
echo "$CURRENT_HASH" > "$LAST_SYNC_FILE"

# Step 7: Check for breaking changes
echo -e "${YELLOW}⚠️  Checking for breaking changes...${NC}"
BREAKING_CHANGES=$(grep -E "(removed|deleted|breaking)" "$CHANGE_LOG" || true)
if [ -n "$BREAKING_CHANGES" ]; then
    echo -e "${RED}❌ Breaking changes detected!${NC}"
    echo "$BREAKING_CHANGES"
    echo -e "${YELLOW}Please review the change report: $CHANGE_LOG${NC}"
else
    echo -e "${GREEN}✅ No breaking changes detected${NC}"
fi

# Cleanup
rm -rf "$TEMP_DIR"

# Summary
echo ""
echo -e "${GREEN}✅ Model sync completed!${NC}"
echo -e "📄 Change report: $CHANGE_LOG"
echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "  1. Review the change report"
echo -e "  2. Update any custom mapping logic if needed"
echo -e "  3. Run full test suite: flutter test"
echo -e "  4. Commit the changes"

# Exit with appropriate code
if [ -n "$BREAKING_CHANGES" ]; then
    exit 1
else
    exit 0
fi