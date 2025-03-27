# 使用官方 Node.js 22 镜像作为基础镜像
FROM node:22

# 设置工作目录
WORKDIR /usr/src/app

# 复制 package.json 和 package-lock.json（如果有）
COPY package*.json ./

# 安装依赖
RUN npm install --legacy-peer-deps

# 创建上传目录
RUN mkdir -p uploads/medical-reports

# 复制项目文件
COPY . .

# 复制启动脚本
COPY backend/scripts/docker_startup.sh /usr/src/app/docker_startup.sh
RUN chmod +x /usr/src/app/docker_startup.sh

# 暴露端口
EXPOSE 3000

# 使用我们的启动脚本作为ENTRYPOINT
ENTRYPOINT ["/usr/src/app/docker_startup.sh"]
CMD ["node", "server.js"]
