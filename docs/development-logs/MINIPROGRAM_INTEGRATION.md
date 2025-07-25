# 小程序集成配置

## 📁 项目结构

```
ai-nutrition-restaurant2025/
├── backend/                    # 后端服务
├── frontend/                   # 前端应用
├── ai-service/                 # AI服务
├── miniprogram/               # 小程序（独立Git仓库）
├── docs/                      # 项目文档
├── docker-compose.yml         # Docker配置
└── README.md                  # 主项目说明
```

## 🔧 小程序独立管理

### 当前配置状态
- ✅ 小程序已初始化独立Git仓库
- ✅ 完整的项目结构和代码
- ✅ 独立的.gitignore和README
- ✅ 89个文件已提交到本地仓库

### 推荐的集成方案

#### 方案一：Git Submodule（推荐）
```bash
# 1. 创建远程仓库
# 在GitHub/GitLab创建: ai-nutrition-miniprogram

# 2. 推送小程序代码
cd miniprogram
git remote add origin https://github.com/your-username/ai-nutrition-miniprogram.git
git push -u origin main

# 3. 在主项目中添加submodule
cd ..
git submodule add https://github.com/your-username/ai-nutrition-miniprogram.git miniprogram

# 4. 提交submodule配置
git add .gitmodules miniprogram
git commit -m "feat: 添加小程序子模块"
```

#### 方案二：独立仓库管理
```bash
# 1. 推送到远程仓库
cd miniprogram
git remote add origin https://github.com/your-username/ai-nutrition-miniprogram.git
git push -u origin main

# 2. 在主项目中忽略miniprogram目录
echo "miniprogram/" >> .gitignore
```

## 🔄 开发工作流

### 小程序开发流程
```bash
# 1. 进入小程序目录
cd miniprogram

# 2. 创建功能分支
git checkout -b feature/new-feature

# 3. 开发和提交
git add .
git commit -m "feat: 新功能开发"

# 4. 推送到远程
git push origin feature/new-feature

# 5. 合并到主分支
git checkout main
git merge feature/new-feature
git push origin main
```

### 主项目更新小程序
```bash
# 如果使用submodule
git submodule update --remote miniprogram
git add miniprogram
git commit -m "chore: 更新小程序到最新版本"
```

## 📊 备份策略

### 多重备份保障
1. **本地Git仓库**: 完整的版本历史
2. **远程仓库**: GitHub/GitLab云端备份
3. **主项目引用**: Submodule方式关联
4. **定时备份**: 自动化备份脚本

### 备份验证
```bash
# 检查本地仓库状态
cd miniprogram
git status
git log --oneline -10

# 检查远程仓库连接
git remote -v

# 检查文件完整性
find . -name "*.js" | wc -l
find . -name "*.json" | wc -l
```

## 🚀 部署配置

### 小程序独立部署
```bash
# 1. 构建小程序
cd miniprogram
npm install
npm run build

# 2. 微信开发者工具上传
# 在微信开发者工具中打开miniprogram目录
# 点击上传，填写版本号和描述

# 3. 微信公众平台审核
# 登录微信公众平台提交审核
```

### CI/CD集成
```yaml
# .github/workflows/miniprogram.yml
name: Miniprogram CI/CD

on:
  push:
    paths:
      - 'miniprogram/**'
  pull_request:
    paths:
      - 'miniprogram/**'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
      with:
        submodules: true
    - name: Setup Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '16'
    - name: Install dependencies
      run: |
        cd miniprogram
        npm install
    - name: Build miniprogram
      run: |
        cd miniprogram
        npm run build
```

## 📋 团队协作

### 权限管理
- **小程序仓库**: 前端团队完全权限
- **主项目仓库**: 全栈团队权限
- **Submodule更新**: 需要协调更新

### 开发分工
- **前端团队**: 专注小程序功能开发
- **后端团队**: 提供API支持
- **AI团队**: 提供AI服务接口
- **DevOps团队**: 负责部署和CI/CD

## 🔧 常见问题解决

### Q: 如何同步主项目的更新？
```bash
# 在小程序目录中
git remote add upstream https://github.com/main-project/ai-nutrition-restaurant2025.git
git fetch upstream
git merge upstream/main
```

### Q: 如何处理冲突？
```bash
# 解决冲突后
git add .
git commit -m "fix: 解决合并冲突"
git push origin main
```

### Q: 如何回滚版本？
```bash
# 回滚到指定版本
git reset --hard <commit-hash>
git push --force origin main
```

## 📞 技术支持

### 相关文档
- [Git Submodule官方文档](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [微信小程序开发文档](https://developers.weixin.qq.com/miniprogram/dev/framework/)
- [Donut多端框架文档](https://donut.tencent.com/)

### 联系方式
- 技术问题: 提交GitHub Issue
- 紧急问题: 联系项目负责人
- 文档更新: 提交Pull Request

---

## ✅ 当前状态总结

### 已完成
- [x] 小程序独立Git仓库初始化
- [x] 完整的项目代码结构
- [x] 89个文件已提交
- [x] 独立的配置和文档

### 下一步操作
1. **创建远程仓库**: 在GitHub/GitLab创建小程序仓库
2. **推送代码**: 将本地代码推送到远程
3. **配置Submodule**: 在主项目中添加子模块引用
4. **团队协作**: 邀请团队成员加入小程序仓库

**小程序现在已经具备了完整的独立Git备份能力！** 🎉
