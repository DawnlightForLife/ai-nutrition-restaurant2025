# 团队协作指南

## 🎯 模块责任分配

### 功能模块负责人
```yaml
features/
├── auth/        # 负责人: @认证团队
├── user/        # 负责人: @用户团队  
├── nutrition/   # 负责人: @营养团队
├── order/       # 负责人: @订单团队
├── merchant/    # 负责人: @商家团队
├── admin/       # 负责人: @管理团队
└── common/      # 负责人: @架构团队
```

### 共享模块（需要架构团队审核）
```yaml
core/           # 核心功能 - 修改需要架构评审
shared/         # 共享组件 - 修改需要设计评审
config/         # 配置文件 - 修改需要技术负责人批准
```

## 📋 开发流程

### 1. 分支管理

```bash
# 从最新的main分支创建功能分支
git checkout main
git pull origin main
git checkout -b feature/[module-name]/[feature-description]

# 分支命名规范
feature/auth/phone-login      # 新功能
bugfix/nutrition/profile-save  # Bug修复
refactor/order/payment-flow    # 重构
```

### 2. 代码审查流程

#### PR提交前检查清单

- [ ] 运行架构检查: `flutter pub run build_runner build`
- [ ] 运行测试: `flutter test`
- [ ] 运行分析: `flutter analyze`
- [ ] 代码格式化: `dart format .`
- [ ] 更新相关文档
- [ ] 没有硬编码值
- [ ] 添加了必要的测试
- [ ] 遵循命名规范

#### PR描述模板

```markdown
## 变更说明
简要描述这个PR的目的

## 变更类型
- [ ] Bug修复
- [ ] 新功能
- [ ] 重构
- [ ] 文档更新

## 测试说明
描述如何测试这些变更

## 相关Issue
Closes #xxx
```

### 3. 代码所有权规则

1. **模块内修改**：模块负责人有最终决定权
2. **跨模块修改**：需要相关模块负责人都同意
3. **核心模块修改**：需要架构团队评审
4. **破坏性变更**：需要团队会议讨论

## 🤝 协作最佳实践

### 1. 沟通优先

- 修改共享代码前在群里说明
- 大的架构调整先写RFC（Request for Comments）
- 遇到不确定的问题及时讨论

### 2. 小步提交

- 每个PR专注于一个功能点
- 避免超过500行的大PR
- 及时合并，减少冲突

### 3. 文档同步

- 代码变更时同步更新文档
- API变更需要更新接口文档
- 新增功能需要添加使用示例

## 🚨 冲突解决

### 合并冲突处理

1. **预防为主**：
   - 每天开始前拉取最新代码
   - 功能完成后尽快提PR
   - 关注其他人正在进行的工作

2. **冲突解决步骤**：
   ```bash
   # 更新本地main分支
   git checkout main
   git pull origin main
   
   # 回到功能分支并rebase
   git checkout feature/your-branch
   git rebase main
   
   # 解决冲突后继续
   git add .
   git rebase --continue
   ```

3. **需要帮助时**：
   - 找相关模块负责人协助
   - 复杂冲突可以开会解决

## 📞 联系方式

### 模块负责人

| 模块 | 负责人 | 联系方式 |
|------|--------|----------|
| 架构 | @架构团队 | architecture@team |
| 认证 | @认证团队 | auth@team |
| 用户 | @用户团队 | user@team |
| 营养 | @营养团队 | nutrition@team |
| 订单 | @订单团队 | order@team |

### 紧急联系

- 技术负责人：@tech-lead
- 项目经理：@pm
- 7x24小时值班：查看值班表

## 相关文档

- [AI开发规则](./ai_development_rules.md)
- [开发指南](./development_guide.md)
- [架构文档](../architecture/ARCHITECTURE_FREEZE.md)