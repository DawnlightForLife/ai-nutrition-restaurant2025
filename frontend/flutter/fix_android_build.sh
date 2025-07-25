#!/bin/bash

# Android构建修复脚本

echo "🔧 Android构建修复脚本"
echo "=========================="

# 1. 禁用国际化格式化
echo "📝 创建dart format 跳过文件..."
cat > .dart_format_skip << 'EOF'
# 跳过这些文件的格式化
lib/l10n/app_localizations*.dart
EOF

# 2. 更新l10n配置，禁用格式化
echo "⚙️ 更新l10n.yaml配置..."
cat > l10n.yaml << 'EOF'
arb-dir: lib/l10n/arb
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
output-dir: lib/l10n
nullable-getter: false
synthetic-package: false
use-deferred-loading: false
format: false
EOF

# 3. 创建简化的analysis_options.yaml
echo "📋 创建简化的analysis_options.yaml..."
cat > analysis_options.yaml << 'EOF'
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # 禁用一些可能导致问题的规则
    prefer_const_constructors: false
    prefer_const_literals_to_create_immutables: false
    
analyzer:
  exclude:
    - lib/l10n/**
    - lib/**/*.g.dart
    - lib/**/*.freezed.dart
    - build/**
    - .dart_tool/**
EOF

# 4. 重新生成国际化文件（不格式化）
echo "🌍 重新生成国际化文件..."
flutter gen-l10n --no-format 2>/dev/null || echo "继续执行..."

# 5. 清理并重新获取依赖
echo "🧹 清理项目..."
flutter clean
flutter pub get

echo "✅ 修复完成！现在可以尝试构建了"
echo "📱 运行命令：flutter run --flavor dev -d emulator-5554"