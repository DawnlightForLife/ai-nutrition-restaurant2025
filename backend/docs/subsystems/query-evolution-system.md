# 数据库查询演化评分系统

## 概述

数据库查询演化评分系统是一个用于评估和优化数据库查询性能的工具。它可以：

1. 在部署前后自动执行慢查询回归评估
2. 生成优化后与优化前的性能差异报告
3. 支持回滚到历史查询策略

本系统有助于保障数据库性能的稳定性，及时发现并解决性能回归问题。

## 核心组件

系统由以下核心组件组成：

- **查询演化评分器** (`queryEvolutionScorer.js`)：评估查询性能并生成报告的核心组件
- **查询回归评估脚本** (`query-regression-evaluator.js`)：用于部署前后自动执行查询性能评估
- **查询策略回滚脚本** (`query-rollback.js`)：支持回滚到历史查询策略
- **部署自动化脚本** (`deploy-with-query-eval.sh`)：集成到部署流程中的自动化脚本
- **查询监控中间件** (`queryMonitor.js`)：捕获和记录数据库查询性能数据

## 使用方法

### 1. 部署前后评估

在应用部署前执行：

```bash
# 部署前评估
node scripts/query-regression-evaluator.js --phase pre --version "v1.2.3" --message "优化了用户查询"

# 输出会包含部署ID，请记录此ID以用于后续步骤
```

完成部署后执行：

```bash
# 部署后评估，使用相同的部署ID
node scripts/query-regression-evaluator.js --phase post --deploymentId "deploy_1652345678901"
```

### 2. 使用部署自动化脚本

更简单的方法是使用自动化脚本：

```bash
# 一键执行部署及前后评估
./scripts/deploy-with-query-eval.sh "v1.2.3" "优化了用户查询"
```

### 3. 查看部署历史

```bash
# 列出最近20次部署
node scripts/query-rollback.js --list
```

### 4. 回滚到历史查询策略

如果发现性能回归问题，可以回滚到之前的查询策略：

```bash
# 回滚到指定部署
node scripts/query-rollback.js --deploymentId "deploy_1652345678901"

# 查看详细信息
node scripts/query-rollback.js --deploymentId "deploy_1652345678901" --verbose

# 强制回滚（即使当前性能良好）
node scripts/query-rollback.js --deploymentId "deploy_1652345678901" --force
```

### 5. 使用自定义查询文件

可以指定自定义的查询文件，而不是使用自动检测的慢查询：

```bash
# 使用自定义查询文件
node scripts/query-regression-evaluator.js --phase pre --version "v1.2.3" --queryFile "./data/sample-queries.js"
```

## 监控与报告

系统自动记录查询性能数据，包括：

- 慢查询记录
- 查询执行计划
- 查询性能变化趋势

生成的性能报告包含以下内容：

- 总体性能评分（-100到100，正值表示改进）
- 改进查询数量和平均改进幅度
- 回归查询数量和平均回归幅度
- 未变化查询数量
- 最严重的性能回归详情
- 优化建议

## 配置选项

配置选项位于 `config/modules/db.config.js` 的 `monitoring` 部分：

- `slowQueryThreshold`: 慢查询阈值（毫秒）
- `logSlowQueries`: 是否记录慢查询
- `sampleRate`: 监控采样率（0-1）
- `collectExplainData`: 是否收集执行计划数据
- `retentionDays`: 监控数据保留天数

## 最佳实践

1. **定期评估性能**：每次部署都执行查询性能评估
2. **保持测试查询一致**：使用一致的测试查询集以便准确比较性能变化
3. **留意评分变化**：总体评分下降5以上需引起关注，下降20以上应考虑回滚
4. **分析执行计划**：对于出现回归的查询，分析其执行计划变化
5. **谨慎回滚**：回滚前确认性能问题确实与查询相关

## 故障排除

### 常见问题

1. **无法获取部署ID**
   - 确保数据库连接正常
   - 检查日志文件中的错误信息

2. **评估结果不准确**
   - 确保使用了足够多样的查询样本
   - 检查测试环境是否与生产环境一致

3. **回滚后仍有性能问题**
   - 检查是否有硬件或网络问题
   - 确认是否有其他应用占用了数据库资源

4. **监控数据量过大**
   - 调整采样率降低数据收集量
   - 减少保留天数
   - 只为慢查询收集执行计划

## 注意事项

- 系统会自动清理超过保留期限的监控数据
- 评估结果受测试环境负载影响，建议在稳定环境下进行测试
- 不要在高峰期执行大量测试查询，以免影响生产环境性能 