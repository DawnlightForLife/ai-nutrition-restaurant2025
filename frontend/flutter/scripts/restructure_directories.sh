#!/bin/bash

# 目录结构重组脚本
echo "🔧 开始重组目录结构..."

# 1. 创建新的顶层目录
mkdir -p lib/l10n
mkdir -p lib/theme

# 2. 移动主题文件
echo "📦 移动主题文件..."
mv lib/shared/theme/* lib/theme/ 2>/dev/null || true
rmdir lib/shared/theme 2>/dev/null || true

# 3. 移动国际化文件
echo "🌍 移动国际化文件..."
mv lib/shared/l10n/* lib/l10n/ 2>/dev/null || true
rmdir lib/shared/l10n 2>/dev/null || true

# 4. 移动 core/widgets 中的通用组件到 shared
echo "🧩 移动通用组件..."
mv lib/core/widgets/async_view.dart lib/shared/widgets/ 2>/dev/null || true

# 5. 清理空目录
find lib -type d -empty -delete 2>/dev/null || true

echo "✅ 目录重组完成！"

# 显示新结构
echo -e "\n📂 新的目录结构："
tree lib -d -L 2 2>/dev/null || ls -la lib/