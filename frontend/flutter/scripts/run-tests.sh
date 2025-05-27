#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Smart Nutrition Restaurant - Test Runner${NC}"
echo -e "${BLUE}==========================================${NC}"

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( cd "$SCRIPT_DIR/.." && pwd )"

cd "$PROJECT_ROOT"

# Parse command line arguments
TEST_TYPE="${1:-all}"
COVERAGE="${2:-false}"

show_usage() {
    echo "Usage: $0 [test-type] [coverage]"
    echo ""
    echo "Test types:"
    echo "  all      - Run all tests (default)"
    echo "  unit     - Run unit tests only"
    echo "  widget   - Run widget tests only"
    echo "  golden   - Run golden tests only"
    echo "  integration - Run integration tests only"
    echo ""
    echo "Coverage:"
    echo "  false    - No coverage report (default)"
    echo "  true     - Generate coverage report"
    echo ""
    echo "Examples:"
    echo "  $0                    # Run all tests"
    echo "  $0 unit true         # Run unit tests with coverage"
    echo "  $0 golden            # Run golden tests only"
}

run_tests() {
    local test_path=$1
    local test_name=$2
    
    echo -e "${YELLOW}Running $test_name...${NC}"
    
    if [ "$COVERAGE" == "true" ]; then
        flutter test --coverage $test_path
    else
        flutter test $test_path
    fi
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ $test_name passed${NC}"
        return 0
    else
        echo -e "${RED}❌ $test_name failed${NC}"
        return 1
    fi
}

# Main test execution
case "$TEST_TYPE" in
    "all")
        echo -e "${BLUE}Running all tests...${NC}"
        FAILED=0
        
        # Unit tests
        run_tests "test/unit" "Unit tests" || FAILED=1
        
        # Widget tests
        run_tests "test/component" "Widget tests" || FAILED=1
        
        # Golden tests
        echo -e "${YELLOW}Running golden tests...${NC}"
        flutter test --update-goldens test/golden || true
        run_tests "test/golden" "Golden tests" || FAILED=1
        
        # Module tests
        for module in test/modules/*; do
            if [ -d "$module" ]; then
                module_name=$(basename "$module")
                run_tests "$module" "$module_name module tests" || FAILED=1
            fi
        done
        
        if [ $FAILED -eq 0 ]; then
            echo -e "${GREEN}🎉 All tests passed!${NC}"
        else
            echo -e "${RED}❌ Some tests failed${NC}"
            exit 1
        fi
        ;;
        
    "unit")
        run_tests "test/unit" "Unit tests"
        ;;
        
    "widget")
        run_tests "test/component" "Widget tests"
        ;;
        
    "golden")
        echo -e "${YELLOW}Updating golden files...${NC}"
        flutter test --update-goldens test/golden
        run_tests "test/golden" "Golden tests"
        ;;
        
    "integration")
        echo -e "${YELLOW}Running integration tests...${NC}"
        flutter test integration_test
        ;;
        
    "help"|"-h"|"--help")
        show_usage
        exit 0
        ;;
        
    *)
        echo -e "${RED}Unknown test type: $TEST_TYPE${NC}"
        show_usage
        exit 1
        ;;
esac

# Generate coverage report if requested
if [ "$COVERAGE" == "true" ] && [ -f "coverage/lcov.info" ]; then
    echo -e "${YELLOW}Generating coverage report...${NC}"
    
    # Install lcov if not present
    if ! command -v lcov &> /dev/null; then
        echo "Installing lcov..."
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew install lcov
        else
            sudo apt-get install -y lcov
        fi
    fi
    
    # Generate HTML report
    genhtml coverage/lcov.info -o coverage/html
    
    # Calculate coverage percentage
    COVERAGE_PCT=$(lcov --summary coverage/lcov.info 2>&1 | grep -E "lines\.\.\.\.\.\.: [0-9]+\.[0-9]+%" | sed 's/.*: \([0-9]*\.[0-9]*\)%.*/\1/')
    
    echo -e "${GREEN}Coverage: $COVERAGE_PCT%${NC}"
    echo -e "${BLUE}Coverage report: coverage/html/index.html${NC}"
    
    # Open coverage report on macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        open coverage/html/index.html
    fi
fi

echo ""
echo -e "${BLUE}Test Summary:${NC}"
echo -e "  Test Type: $TEST_TYPE"
echo -e "  Coverage: $COVERAGE"

# Create test report
REPORT_FILE="test-report-$(date +%Y%m%d-%H%M%S).txt"
echo "Test Report - $(date)" > "$REPORT_FILE"
echo "Test Type: $TEST_TYPE" >> "$REPORT_FILE"
echo "Coverage: $COVERAGE" >> "$REPORT_FILE"
if [ "$COVERAGE" == "true" ] && [ -n "$COVERAGE_PCT" ]; then
    echo "Coverage Percentage: $COVERAGE_PCT%" >> "$REPORT_FILE"
fi

echo -e "${BLUE}Report saved to: $REPORT_FILE${NC}"