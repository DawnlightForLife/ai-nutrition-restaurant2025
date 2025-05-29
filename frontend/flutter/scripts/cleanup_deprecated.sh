#!/bin/bash

# 清理废弃和重复文件的脚本
echo "🧹 开始清理废弃文件..."

# 删除重复的 Facade
rm -f lib/features/auth/presentation/facades/auth_facade.dart
rm -f lib/features/nutrition/presentation/facades/nutrition_facade.dart

# 删除废弃的全局 providers index
rm -f lib/core/providers/providers_index.dart

# 删除旧的事件总线
rm -f lib/core/services/event_bus.dart

# 删除旧的错误处理器
rm -f lib/core/error/error_handler.dart

# 移动路由生成文件到正确位置
mkdir -p .dart_tool/build/generated/ai_nutrition_restaurant/lib/core/router/
mv lib/core/router/app_router.gr.dart .dart_tool/build/generated/ai_nutrition_restaurant/lib/core/router/ 2>/dev/null || true

echo "✅ 清理完成"