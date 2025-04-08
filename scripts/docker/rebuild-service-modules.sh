#!/bin/bash
# 服务模块路径重构后的Docker构建脚本
# 用于确保新的服务模块路径被正确构建并部署

# 获取当前时间戳作为缓存刷新参数
CACHEBUST=$(date +%s)

# 输出开始构建的信息
echo "正在重建服务模块，刷新缓存..."
echo "刷新时间戳: $CACHEBUST"

# 检查Docker是否运行
if ! docker info > /dev/null 2>&1; then
  echo "错误: Docker 服务未运行，请先启动 Docker"
  exit 1
fi

# 停止现有容器
echo "停止现有容器..."
docker-compose down || echo "无现有容器需要停止"

# 重建镜像，使用缓存刷新参数
echo "重新构建镜像，强制更新服务模块..."
docker-compose build --build-arg CACHEBUST=$CACHEBUST

# 启动新容器
echo "启动新容器..."
docker-compose up -d

# 显示运行中的容器
echo "运行中的容器:"
docker-compose ps

echo "服务模块重建完成"
echo "请检查服务日志，确保所有服务正常启动和运行"
echo "可使用 'docker-compose logs' 查看详细日志" 