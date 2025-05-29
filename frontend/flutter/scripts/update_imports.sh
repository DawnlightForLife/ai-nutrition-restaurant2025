#!/bin/bash

echo "🔄 更新导入路径..."

# 更新主题导入
find lib -name "*.dart" -type f -exec sed -i '' 's|shared/theme/|theme/|g' {} \;

# 更新国际化导入
find lib -name "*.dart" -type f -exec sed -i '' 's|shared/l10n/|l10n/|g' {} \;

# 更新相对路径导入（../../../../shared/theme -> ../../../../theme）
find lib -name "*.dart" -type f -exec sed -i '' 's|/shared/theme/|/theme/|g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' 's|/shared/l10n/|/l10n/|g' {} \;

echo "✅ 导入路径更新完成！"