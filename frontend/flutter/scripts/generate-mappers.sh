#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

echo -e "${YELLOW}🔄 Starting mapper generation...${NC}"

cd "$PROJECT_ROOT"

# Step 1: Scan DTOs and Entities
echo -e "${YELLOW}📊 Scanning DTOs and Entities...${NC}"

# Create mapper generation configuration
cat > lib/infrastructure/mappers/mapper_config.dart << 'EOF'
// Auto-generated mapper configuration
// DO NOT EDIT MANUALLY

import 'package:smart_nutrition_frontend/infrastructure/mappers/mapper_generator.dart';

// User mappers
@GenerateMapper(
  dtoType: UserDto,
  entityType: User,
)
class UserMapperConfig {}

// Restaurant mappers
@GenerateMapper(
  dtoType: RestaurantDto,
  entityType: Restaurant,
)
class RestaurantMapperConfig {}

// Order mappers
@GenerateMapper(
  dtoType: OrderDto,
  entityType: Order,
)
class OrderMapperConfig {}

// Nutrition mappers
@GenerateMapper(
  dtoType: NutritionProfileDto,
  entityType: NutritionProfile,
)
class NutritionProfileMapperConfig {}

// Dish mappers
@GenerateMapper(
  dtoType: DishDto,
  entityType: Dish,
)
class DishMapperConfig {}
EOF

# Step 2: Generate mapper classes
echo -e "${YELLOW}🏗️ Generating mapper classes...${NC}"

# Create a simple mapper generator script
dart run --enable-asserts scripts/mapper_generator.dart

# Step 3: Format generated code
echo -e "${YELLOW}🎨 Formatting generated mappers...${NC}"
dart format lib/infrastructure/mappers/generated/

# Step 4: Analyze generated code
echo -e "${YELLOW}🔍 Analyzing generated mappers...${NC}"
dart analyze lib/infrastructure/mappers/generated/ || true

echo -e "${GREEN}✅ Mapper generation completed!${NC}"

# Display summary
echo ""
echo -e "${YELLOW}📋 Generated mappers:${NC}"
find lib/infrastructure/mappers/generated -name "*.dart" -type f | sort

echo ""
echo -e "${YELLOW}💡 Usage example:${NC}"
echo -e "final userMapper = UserMapper();"
echo -e "final entity = userMapper.toEntity(dto);"
echo -e "final dto = userMapper.toDto(entity);"