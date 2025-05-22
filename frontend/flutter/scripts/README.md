# 构建脚本集合

本目录包含各种用于项目构建、自动化生成和代码分析的脚本。

## 可用脚本

### 1. 依赖注入生成器 (generate_di.sh)

用于生成依赖注入配置，清理和重新生成依赖注入相关的自动代码。

**用法：**

```bash
# 给脚本执行权限
chmod +x scripts/generate_di.sh

# 执行脚本
./scripts/generate_di.sh
```

**功能：**

- 清理旧的自动生成文件
- 运行build_runner生成新的依赖注入配置
- 提供排查依赖注入问题的建议

**注意事项：**

- 所有服务实现类应添加 `@LazySingleton(as: IxxxService)` 注解
- 所有仓库实现类应添加 `@LazySingleton(as: IxxxRepository)` 注解
- 所有用例类应添加 `@injectable` 注解
- 接口类不需要添加注解

更多信息请参考 `lib/core/di/README.md`。 