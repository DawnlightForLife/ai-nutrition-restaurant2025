#!/bin/bash

# 确保在根目录运行
cd "$(dirname "$0")/.." || exit

# 确保依赖已安装
command -v mason >/dev/null 2>&1 || {
  echo "安装 Mason CLI..."
  dart pub global activate mason_cli
}

# 参数验证
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "错误: 请提供组件名称和类别"
  echo "用法: ./scripts/create_widget.sh <组件名称> <类别> [组件描述]"
  echo "类别可选: buttons, cards, inputs, indicators, navigation"
  exit 1
fi

WIDGET_NAME=$1
CATEGORY=$2
WIDGET_DESC=${3:-"$WIDGET_NAME 组件"}

# 使用Mason生成组件
echo "创建 $CATEGORY/$WIDGET_NAME 组件..."
mason make widget --name "$WIDGET_NAME" --category "$CATEGORY" --description "$WIDGET_DESC"

echo "组件 $WIDGET_NAME 创建完成！" 