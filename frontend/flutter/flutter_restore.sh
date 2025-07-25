#!/bin/bash

# Flutter恢复脚本 - 恢复原始配置

echo "🔄 Flutter配置恢复脚本"
echo "=========================="

# 恢复l10n配置
if [ -f "l10n.yaml.backup" ]; then
    mv l10n.yaml.backup l10n.yaml
    echo "✅ l10n.yaml已恢复"
fi

# 恢复pubspec.yaml
if [ -f "pubspec.yaml.backup" ]; then
    mv pubspec.yaml.backup pubspec.yaml
    echo "✅ pubspec.yaml已恢复"
fi

# 删除临时文件
rm -rf lib/l10n/app_localizations_delegate.dart

echo "🎉 配置恢复完成！"