#!/bin/bash

# 确保在根目录运行
cd "$(dirname "$0")/.." || exit

# 确保依赖已安装
command -v mason >/dev/null 2>&1 || {
  echo "安装 Mason CLI..."
  dart pub global activate mason_cli
}

# 参数验证
if [ -z "$1" ]; then
  echo "错误: 请提供模块名称"
  echo "用法: ./scripts/create_module.sh <模块名称> [模块描述]"
  exit 1
fi

MODULE_NAME=$1
MODULE_DESC=${2:-"$MODULE_NAME 功能模块"}

# 使用Mason生成模块
echo "创建 $MODULE_NAME 模块..."
mason make feature_module --name "$MODULE_NAME" --description "$MODULE_DESC"

echo "模块 $MODULE_NAME 创建完成！"

# 进入项目目录
cd ai-nutrition-restaurant2025/frontend/flutter

# 初始化Mason
mason init

# 创建一个新砖块
mason new feature_module 