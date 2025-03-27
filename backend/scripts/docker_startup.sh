#!/bin/bash

# Docker容器启动脚本
# 此脚本在容器启动时运行，用于初始化环境和检查依赖

echo "========== 容器启动脚本 =========="

# 确保工作目录正确
cd /usr/src/app || {
    echo "错误: 无法切换到应用目录"
    exit 1
}

# 检查模型文件导入问题
echo "检查模型文件导入..."
if [ -f "/usr/src/app/backend/scripts/fix_model_imports_prod.js" ]; then
    echo "执行模型导入修复脚本..."
    node /usr/src/app/backend/scripts/fix_model_imports_prod.js
else
    # 直接修复healthDataModel.js文件
    echo "执行特定文件修复..."
    if [ -f "/usr/src/app/models/healthDataModel.js" ]; then
        # 如果文件存在但没有导入ModelFactory
        if grep -q "ModelFactory.model" "/usr/src/app/models/healthDataModel.js" && ! grep -q "require('./modelFactory')" "/usr/src/app/models/healthDataModel.js"; then
            echo "修复/usr/src/app/models/healthDataModel.js..."
            # 使用sed在第二行添加ModelFactory导入
            sed -i '2a const ModelFactory = require("./modelFactory");' "/usr/src/app/models/healthDataModel.js"
            echo "文件已修复"
        else
            echo "文件已正确导入ModelFactory或不需要修复"
        fi
    else
        echo "警告: healthDataModel.js文件不存在"
    fi
fi

# 启动应用
echo "启动应用..."
exec "$@" 