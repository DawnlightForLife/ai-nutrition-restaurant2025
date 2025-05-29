#!/bin/bash

# 文档整合脚本
echo "📚 开始整合文档..."

# 1. 创建统一的文档目录结构
mkdir -p docs/modules
mkdir -p docs/guides
mkdir -p docs/api

# 2. 移动模块 README 到统一位置
for module_dir in lib/features/*/; do
  if [ -f "$module_dir/README.md" ]; then
    module_name=$(basename "$module_dir")
    mv "$module_dir/README.md" "docs/modules/${module_name}.md" 2>/dev/null
  fi
done

# 3. 创建模块文档索引
cat > docs/modules/INDEX.md << 'EOF'
# 模块文档索引

## 功能模块

| 模块 | 说明 | 文档 |
|------|------|------|
| auth | 认证模块 | [auth.md](auth.md) |
| user | 用户模块 | [user.md](user.md) |
| nutrition | 营养模块 | [nutrition.md](nutrition.md) |
| order | 订单模块 | [order.md](order.md) |
| recommendation | 推荐模块 | [recommendation.md](recommendation.md) |
| consultation | 咨询模块 | [consultation.md](consultation.md) |
| forum | 论坛模块 | [forum.md](forum.md) |
| merchant | 商家模块 | [merchant.md](merchant.md) |
| admin | 管理员模块 | [admin.md](admin.md) |
| nutritionist | 营养师模块 | [nutritionist.md](nutritionist.md) |

## 相关文档

- [架构设计](../ARCHITECTURE.md)
- [开发指南](../guides/DEVELOPMENT_GUIDE.md)
- [API 文档](../api/README.md)
EOF

echo "✅ 文档整合完成！"