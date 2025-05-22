#!/bin/bash

# 智能营养餐厅App - 依赖注入生成脚本
# 此脚本用于清理并重新生成依赖注入配置

echo "===== 智能营养餐厅App - 依赖注入生成工具 ====="
echo "正在清理旧的生成文件..."

# 删除生成的文件
find . -name "*.g.dart" -type f -delete
find . -name "*.config.dart" -type f -delete
rm -rf .dart_tool/build

echo "正在清理完成，开始生成新配置..."

# 运行生成命令
flutter pub run build_runner build --delete-conflicting-outputs

# 检查生成结果
if [ $? -eq 0 ]; then
  echo "===== 依赖注入配置生成成功 ====="
  echo "提示：如果你看到有关未注册类型的警告，请确保:"
  echo "1. 所有服务实现类添加 @LazySingleton(as: IxxxService) 注解"
  echo "2. 所有仓库实现类添加 @LazySingleton(as: IxxxRepository) 注解" 
  echo "3. 所有用例类添加 @injectable 注解"
else
  echo "===== 依赖注入配置生成失败，请检查错误信息 ====="
fi

echo "完成！" 