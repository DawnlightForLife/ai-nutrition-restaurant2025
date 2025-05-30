#!/bin/bash

echo "=== Files importing from core/error/ ==="
grep -r "import.*core/error/" ../.. --include="*.dart" | grep -v "ERROR_CONSOLIDATION_PLAN"

echo -e "\n=== Files importing from core/exceptions/ ==="
grep -r "import.*core/exceptions/" ../.. --include="*.dart"

echo -e "\n=== Files using AppException classes ==="
grep -r "AppException\|NetworkException\|ServerException\|AuthException\|ValidationException\|CacheException" ../.. --include="*.dart" | grep -v "class.*Exception" | head -20

echo -e "\n=== Files using Failure classes ==="
grep -r "Failure" ../.. --include="*.dart" | grep -v "class.*Failure" | head -20