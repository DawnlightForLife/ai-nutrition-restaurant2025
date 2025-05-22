#!/bin/bash
echo '🚀 正在生成 OpenAPI 文档...'
node backend/docs/swagger-generate.js

echo '🚀 正在生成 Dart 模型代码...'
openapi-generator generate \
  -i backend/docs/integrations/swagger-openapi.yaml \
  -g dart-dio \
  -o frontend/flutter/lib/services/generated \
  --additional-properties=pubName=smart_nutrition_api,nullableFields=true

echo '✅ 模型同步完成！' 