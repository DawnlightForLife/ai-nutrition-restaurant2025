#!/bin/bash

# 测试覆盖率脚本

set -e

echo "🧪 开始运行测试并生成覆盖率报告..."

# 清理之前的覆盖率数据
rm -rf coverage/

# 运行测试并生成覆盖率
flutter test --coverage

# 生成 HTML 报告
if command -v genhtml &> /dev/null; then
    genhtml coverage/lcov.info -o coverage/html
    echo "📊 HTML 覆盖率报告已生成: coverage/html/index.html"
fi

# 显示覆盖率摘要
if command -v lcov &> /dev/null; then
    echo ""
    echo "📈 覆盖率摘要:"
    lcov --summary coverage/lcov.info
fi

# 检查覆盖率是否达到目标
if command -v lcov &> /dev/null; then
    COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep -E "lines.*:" | sed 's/.*: \([0-9.]*\)%.*/\1/')
    
    echo ""
    echo "当前覆盖率: ${COVERAGE}%"
    
    # 检查是否达到 90% 的目标
    if (( $(echo "$COVERAGE >= 90" | bc -l) )); then
        echo "✅ 覆盖率达标！"
    else
        echo "❌ 覆盖率未达到 90% 的目标"
        echo "需要继续添加测试以提高覆盖率"
    fi
fi

# 在 macOS 上自动打开报告
if [[ "$OSTYPE" == "darwin"* ]] && [[ -f "coverage/html/index.html" ]]; then
    open coverage/html/index.html
fi