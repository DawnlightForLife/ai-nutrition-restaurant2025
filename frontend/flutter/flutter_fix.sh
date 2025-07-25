#!/bin/bash

# Flutter修复脚本 - 绕过国际化生成问题
# 这个脚本会暂时禁用国际化自动生成，直接启动Flutter应用

echo "🔧 Flutter启动修复脚本"
echo "=========================="

# 1. 设置代理环境
echo "📡 设置代理环境..."
export HTTP_PROXY="http://127.0.0.1:1082"
export HTTPS_PROXY="http://127.0.0.1:1082"
export ALL_PROXY="socks5://127.0.0.1:1082"
export NO_PROXY="localhost,127.0.0.1,::1"
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# 2. 备份和禁用l10n配置
echo "💾 备份l10n配置..."
if [ -f "l10n.yaml" ]; then
    cp l10n.yaml l10n.yaml.backup
    echo "generate: false" > l10n.yaml
fi

# 3. 暂时禁用pubspec.yaml中的国际化生成
echo "🔧 暂时禁用pubspec.yaml中的国际化生成..."
if [ -f "pubspec.yaml" ]; then
    cp pubspec.yaml pubspec.yaml.backup
    sed -i '' '/generate: true/d' pubspec.yaml
fi

# 4. 删除有问题的生成文件
echo "🗑️  删除有问题的生成文件..."
rm -rf lib/l10n/app_localizations*.dart
rm -rf .dart_tool/flutter_gen/

# 5. 重新获取依赖
echo "📦 重新获取依赖..."
flutter pub get --no-generate

# 6. 手动创建简化的国际化文件
echo "📝 创建简化的国际化文件..."
mkdir -p lib/l10n

# 创建简化的国际化基类
cat > lib/l10n/app_localizations.dart << 'EOF'
import 'package:flutter/material.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // 添加你的国际化字符串
  String get appTitle => 'AI营养餐厅';
  String get welcome => '欢迎';
  String get loading => '加载中...';
  String get error => '错误';
  String get retry => '重试';
  String get ok => '确定';
  String get cancel => '取消';
}

class AppLocalizationsZh extends AppLocalizations {
  @override
  String get appTitle => 'AI营养餐厅';
  @override
  String get welcome => '欢迎';
  @override
  String get loading => '加载中...';
  @override
  String get error => '错误';
  @override
  String get retry => '重试';
  @override
  String get ok => '确定';
  @override
  String get cancel => '取消';
}

class AppLocalizationsEn extends AppLocalizations {
  @override
  String get appTitle => 'AI Nutrition Restaurant';
  @override
  String get welcome => 'Welcome';
  @override
  String get loading => 'Loading...';
  @override
  String get error => 'Error';
  @override
  String get retry => 'Retry';
  @override
  String get ok => 'OK';
  @override
  String get cancel => 'Cancel';
}
EOF

# 创建Delegate
cat > lib/l10n/app_localizations_delegate.dart << 'EOF'
import 'package:flutter/material.dart';
import 'app_localizations.dart';

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'zh':
        return AppLocalizationsZh();
      case 'en':
      default:
        return AppLocalizationsEn();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
EOF

# 7. 尝试启动Flutter应用
echo "🚀 尝试启动Flutter应用..."
flutter run --no-sound-null-safety || echo "如果仍有问题，请手动运行: flutter run --no-sound-null-safety"

# 8. 恢复配置（可选）
echo "🔄 如果需要恢复原配置，请运行: ./flutter_restore.sh"