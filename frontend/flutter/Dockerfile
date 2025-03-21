# Stage 1: Build Flutter Web Application
FROM cirrusci/flutter:latest AS builder

# 允许以 root 运行 Flutter
ENV FLUTTER_ALLOW_ROOT=true

# 设置工作目录为项目根目录，确保该目录下有 pubspec.yaml
WORKDIR /app

# 复制当前构建上下文的所有文件到容器中
COPY . .

# 可选：列出当前目录文件，确认 pubspec.yaml 存在
RUN ls -la /app

# 安装 Flutter 依赖
RUN flutter pub get

# 构建 Flutter Web 应用（生成到 /app/build/web）
RUN flutter build web

# Stage 2: Serve with Nginx
FROM nginx:alpine

# 复制构建产物到 Nginx 默认的静态文件目录
COPY --from=builder /app/build/web /usr/share/nginx/html

# 暴露 80 端口
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
