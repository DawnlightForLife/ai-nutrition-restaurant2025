#!/bin/bash

# 确保在根目录运行
cd "$(dirname "$0")/.." || exit

# 清理旧的覆盖率数据
rm -rf coverage
mkdir -p coverage

# 为Golden测试创建lcov.ignore文件（如果不存在）
if [ ! -f "lcov.ignore" ]; then
  cat > lcov.ignore << EOF
**/widgetbook/**
**/generated/**
**/mock_*.dart
**/*.g.dart
**/*.freezed.dart
EOF
fi

# 运行测试并生成覆盖率报告（排除golden测试，除非指定了--golden参数）
if [ "$1" == "--golden" ]; then
  echo "运行包括Golden测试在内的所有测试..."
  flutter test --coverage
else
  echo "运行单元测试和Widget测试（不包括Golden测试）..."
  flutter test --coverage --exclude-tags=golden
fi

# 从覆盖率报告中排除指定的文件
if [ -f "lcov.ignore" ]; then
  echo "从覆盖率报告中排除指定的文件..."
  lcov --remove coverage/lcov.info -o coverage/lcov.info $(cat lcov.ignore | tr '\n' ' ')
fi

# 生成HTML覆盖率报告
genhtml coverage/lcov.info -o coverage/html

# 如果在CI环境运行，显示覆盖率摘要
if [ -n "$CI" ]; then
  echo "覆盖率报告已生成"
  lcov --summary coverage/lcov.info
fi

echo "测试覆盖率报告已生成到 coverage/html 目录"

# 打开覆盖率报告（非CI环境）
if [ -z "$CI" ] && [ "$(uname)" == "Darwin" ]; then
  open coverage/html/index.html
elif [ -z "$CI" ] && [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  xdg-open coverage/html/index.html 2>/dev/null
fi 