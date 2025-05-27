#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧹 Smart Nutrition Restaurant - Clean Rebuild Script${NC}"
echo -e "${BLUE}====================================================${NC}"

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

cd "$PROJECT_ROOT"

# Step 1: Clean Flutter
echo -e "${YELLOW}1. Cleaning Flutter project...${NC}"
flutter clean
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Flutter clean completed${NC}"
else
    echo -e "${RED}❌ Flutter clean failed${NC}"
    exit 1
fi

# Step 2: Clean Android build
echo -e "${YELLOW}2. Cleaning Android build...${NC}"
cd android
./gradlew clean --no-daemon
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Android clean completed${NC}"
else
    echo -e "${RED}❌ Android clean failed${NC}"
fi
cd ..

# Step 3: Remove build directories
echo -e "${YELLOW}3. Removing build directories...${NC}"
rm -rf build/
rm -rf android/app/build/
rm -rf android/.gradle/
rm -rf ios/Pods/
rm -rf ios/.symlinks/
echo -e "${GREEN}✅ Build directories removed${NC}"

# Step 4: Get packages
echo -e "${YELLOW}4. Getting Flutter packages...${NC}"
flutter pub get
if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ Packages retrieved${NC}"
else
    echo -e "${RED}❌ Failed to get packages${NC}"
    exit 1
fi

# Step 5: Generate code (if needed)
echo -e "${YELLOW}5. Running code generation...${NC}"
if [ -f "pubspec.yaml" ] && grep -q "build_runner" pubspec.yaml; then
    flutter pub run build_runner build --delete-conflicting-outputs
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Code generation completed${NC}"
    else
        echo -e "${YELLOW}⚠️  Code generation had issues${NC}"
    fi
else
    echo -e "${BLUE}ℹ️  No code generation needed${NC}"
fi

# Step 6: Verify Android setup
echo -e "${YELLOW}6. Verifying Android setup...${NC}"
if [ -f "android/app/google-services.json" ]; then
    echo -e "${GREEN}✅ google-services.json found${NC}"
else
    echo -e "${YELLOW}⚠️  google-services.json not found - Firebase features will be disabled${NC}"
fi

# Step 7: Create required directories
echo -e "${YELLOW}7. Creating required directories...${NC}"
mkdir -p assets/images
mkdir -p assets/icons
mkdir -p assets/i18n
echo -e "${GREEN}✅ Asset directories created${NC}"

# Summary
echo ""
echo -e "${GREEN}🎉 Clean rebuild completed!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Run the app: ${BLUE}flutter run${NC}"
echo -e "  2. Build APK: ${BLUE}flutter build apk${NC}"
echo -e "  3. Run tests: ${BLUE}flutter test${NC}"
echo ""
echo -e "${YELLOW}If you still encounter issues:${NC}"
echo -e "  1. Check ${BLUE}docs/ANDROID_SETUP_GUIDE.md${NC}"
echo -e "  2. Restart your IDE"
echo -e "  3. Invalidate caches in Android Studio"

# Optional: Run the app
read -p "Do you want to run the app now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    flutter run
fi