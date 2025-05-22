#!/bin/bash

# 部署时查询性能评估自动化脚本
# 使用方式：./deploy-with-query-eval.sh <版本号> <部署描述>

set -e  # 遇到错误立即退出

# 获取脚本参数
VERSION=$1
DESCRIPTION=$2

# 检查必需参数
if [ -z "$VERSION" ]; then
  echo "错误: 必须提供版本号"
  echo "用法: $0 <版本号> <部署描述>"
  exit 1
fi

if [ -z "$DESCRIPTION" ]; then
  DESCRIPTION="部署版本 $VERSION"
fi

# 定义日志文件
LOG_DIR="./logs/deployments"
mkdir -p $LOG_DIR
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="$LOG_DIR/deploy_${VERSION}_${TIMESTAMP}.log"

# 记录日志的函数
log() {
  echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1" | tee -a $LOG_FILE
}

# 部署前评估
pre_deployment_evaluation() {
  log "开始部署前查询性能评估..."
  
  # 运行部署前评估脚本
  DEPLOYMENT_ID=$(node scripts/query-regression-evaluator.js --phase pre --version "$VERSION" --message "$DESCRIPTION" | grep "部署ID:" | cut -d ":" -f2 | tr -d ' ')
  
  if [ -z "$DEPLOYMENT_ID" ]; then
    log "错误: 部署前评估失败，无法获取部署ID"
    exit 1
  fi
  
  log "部署前评估完成，部署ID: $DEPLOYMENT_ID"
  echo $DEPLOYMENT_ID
}

# 执行部署
perform_deployment() {
  local deployment_id=$1
  
  log "开始执行部署 $VERSION..."
  
  # 记录部署开始时间
  DEPLOY_START_TIME=$(date +%s)
  
  # 这里放置您的实际部署步骤
  # 例如: npm run build && pm2 restart your-app
  
  # 模拟部署过程
  log "正在构建应用..."
  sleep 2
  
  log "正在重启服务..."
  sleep 3
  
  # 记录部署结束时间
  DEPLOY_END_TIME=$(date +%s)
  DEPLOY_DURATION=$((DEPLOY_END_TIME - DEPLOY_START_TIME))
  
  log "部署完成，耗时 $DEPLOY_DURATION 秒"
}

# 部署后评估
post_deployment_evaluation() {
  local deployment_id=$1
  
  log "开始部署后查询性能评估..."
  
  # 运行部署后评估脚本
  node scripts/query-regression-evaluator.js --phase post --deploymentId "$deployment_id" --output "./logs/query-reports" >> $LOG_FILE 2>&1
  
  # 检查是否有性能回归
  if grep -q "警告: 检测到.*个查询性能回归" $LOG_FILE; then
    log "警告: 检测到查询性能回归，请检查详细报告"
    HAS_REGRESSION=1
  else
    log "未检测到明显的查询性能回归"
    HAS_REGRESSION=0
  fi
  
  # 提取性能评分
  PERFORMANCE_SCORE=$(grep "总体评分:" $LOG_FILE | tail -1 | cut -d ":" -f2 | cut -d " " -f2)
  
  if [ -n "$PERFORMANCE_SCORE" ]; then
    log "查询性能评分: $PERFORMANCE_SCORE"
    
    # 如果性能评分为负且较低，提示可能需要回滚
    if (( $(echo "$PERFORMANCE_SCORE < -20" | bc -l) )); then
      log "警告: 性能评分显著为负，建议考虑回滚"
      log "可以使用以下命令回滚: node scripts/query-rollback.js --deploymentId $deployment_id"
      HAS_REGRESSION=1
    fi
  fi
  
  return $HAS_REGRESSION
}

# 创建部署摘要报告
create_summary_report() {
  local deployment_id=$1
  local has_regression=$2
  local report_file="$LOG_DIR/summary_${VERSION}_${TIMESTAMP}.txt"
  
  log "生成部署摘要报告..."
  
  echo "========== 部署摘要报告 ==========" > $report_file
  echo "版本: $VERSION" >> $report_file
  echo "描述: $DESCRIPTION" >> $report_file
  echo "部署ID: $deployment_id" >> $report_file
  echo "部署时间: $(date +'%Y-%m-%d %H:%M:%S')" >> $report_file
  echo "部署耗时: $DEPLOY_DURATION 秒" >> $report_file
  echo "" >> $report_file
  
  echo "========== 查询性能评估 ==========" >> $report_file
  if [ -n "$PERFORMANCE_SCORE" ]; then
    echo "性能评分: $PERFORMANCE_SCORE (-100到100，正值表示改进)" >> $report_file
  fi
  
  if [ $has_regression -eq 1 ]; then
    echo "⚠️ 警告: 检测到查询性能回归" >> $report_file
    echo "详细回归信息请查看日志文件: $LOG_FILE" >> $report_file
    echo "可以使用以下命令回滚: node scripts/query-rollback.js --deploymentId $deployment_id" >> $report_file
  else
    echo "✅ 未检测到明显的查询性能回归" >> $report_file
  fi
  
  log "摘要报告已保存至: $report_file"
  
  # 显示报告内容
  cat $report_file
}

# 主流程
main() {
  log "开始部署流程，版本: $VERSION，描述: $DESCRIPTION"
  
  # 执行部署前评估
  DEPLOYMENT_ID=$(pre_deployment_evaluation)
  
  # 执行部署
  perform_deployment $DEPLOYMENT_ID
  
  # 执行部署后评估
  post_deployment_evaluation $DEPLOYMENT_ID
  HAS_REGRESSION=$?
  
  # 创建摘要报告
  create_summary_report $DEPLOYMENT_ID $HAS_REGRESSION
  
  log "部署流程完成"
  
  # 如果有性能回归，以非零状态退出
  if [ $HAS_REGRESSION -eq 1 ]; then
    log "由于检测到性能回归，退出状态为1"
    exit 1
  fi
  
  exit 0
}

# 执行主流程
main 