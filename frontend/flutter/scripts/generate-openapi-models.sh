#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"
BACKEND_ROOT="$( cd "$PROJECT_ROOT/../../backend" && pwd )"
OPENAPI_SPEC="$PROJECT_ROOT/../../docs/openapi/openapi.yaml"

echo -e "${YELLOW}🚀 Starting OpenAPI model generation...${NC}"

# Check if openapi-generator is installed
if ! command -v openapi-generator &> /dev/null; then
    echo -e "${RED}❌ openapi-generator is not installed!${NC}"
    echo "Please install it using: brew install openapi-generator"
    exit 1
fi

# Step 1: Generate/Update OpenAPI spec from backend
echo -e "${YELLOW}📝 Generating OpenAPI spec from backend...${NC}"
cd "$BACKEND_ROOT"
if [ -f "docs/swagger-generate.js" ]; then
    node docs/swagger-generate.js
    echo -e "${GREEN}✅ OpenAPI spec generated${NC}"
else
    echo -e "${RED}❌ swagger-generate.js not found${NC}"
    exit 1
fi

cd "$PROJECT_ROOT"

# Step 2: Clean previous generated files
echo -e "${YELLOW}🧹 Cleaning previous generated files...${NC}"
rm -rf lib/infrastructure/dtos/generated
rm -rf lib/infrastructure/api_client/generated

# Step 3: Generate DTOs (Models only)
echo -e "${YELLOW}📦 Generating DTO models...${NC}"
openapi-generator generate \
    -c openapi-generator-config.yaml \
    -t templates/dart-dto \
    --global-property models \
    --skip-validate-spec

# Step 4: Generate API Client
echo -e "${YELLOW}🔌 Generating API client...${NC}"
openapi-generator generate \
    -i "$OPENAPI_SPEC" \
    -g dart-dio \
    -o lib/infrastructure/api_client/generated \
    --additional-properties=pubName=smart_nutrition_api_client,nullableFields=true,splitModels=true \
    --global-property apis,supportingFiles \
    --skip-validate-spec

# Step 5: Generate Mappers for DTOs
echo -e "${YELLOW}🔄 Generating mappers...${NC}"
dart run build_runner build --delete-conflicting-outputs

# Step 6: Format generated code
echo -e "${YELLOW}🎨 Formatting generated code...${NC}"
dart format lib/infrastructure/dtos/generated/
dart format lib/infrastructure/api_client/generated/

# Step 7: Analyze generated code
echo -e "${YELLOW}🔍 Analyzing generated code...${NC}"
dart analyze lib/infrastructure/dtos/generated/ || true
dart analyze lib/infrastructure/api_client/generated/ || true

# Step 8: Generate change report
echo -e "${YELLOW}📊 Generating change report...${NC}"
REPORT_FILE="$PROJECT_ROOT/docs/api-changes-$(date +%Y%m%d-%H%M%S).md"
echo "# API Changes Report - $(date)" > "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## Generated DTOs" >> "$REPORT_FILE"
find lib/infrastructure/dtos/generated -name "*.dart" -type f | sort >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"
echo "## Generated API Clients" >> "$REPORT_FILE"
find lib/infrastructure/api_client/generated -name "*.dart" -type f | sort >> "$REPORT_FILE"

echo -e "${GREEN}✅ Model generation completed!${NC}"
echo -e "${GREEN}📄 Change report saved to: $REPORT_FILE${NC}"

# Display summary
echo ""
echo -e "${YELLOW}📋 Summary:${NC}"
echo -e "  • DTOs generated in: lib/infrastructure/dtos/generated/"
echo -e "  • API Client generated in: lib/infrastructure/api_client/generated/"
echo -e "  • Change report: $REPORT_FILE"
echo ""
echo -e "${YELLOW}💡 Next steps:${NC}"
echo -e "  1. Review generated models"
echo -e "  2. Run mapper generation: dart run build_runner build"
echo -e "  3. Update domain entities if needed"
echo -e "  4. Run tests to ensure compatibility"