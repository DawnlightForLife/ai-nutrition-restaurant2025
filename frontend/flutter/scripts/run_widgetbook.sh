#!/bin/bash

# 确保在根目录运行
cd "$(dirname "$0")/.." || exit

# 确保依赖已安装
flutter pub get

# 运行Widgetbook
flutter run -t lib/widgetbook/widgetbook_main.dart 