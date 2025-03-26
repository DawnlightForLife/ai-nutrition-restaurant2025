# 1. 使用 Flutter 官方镜像
FROM ghcr.io/cirruslabs/flutter:stable AS builder

# 2. 复制 Flutter SDK 到可写目录（避免 `/sdks/flutter` 只读问题）
RUN cp -r /sdks/flutter /opt/flutter && \
    chown -R root:root /opt/flutter && \
    chmod -R 777 /opt/flutter

# 3. 设置 Flutter SDK 目录（绕开 `/sdks/flutter`）
ENV FLUTTER_HOME=/opt/flutter
ENV PATH="$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH"

# 4. 设置工作目录
WORKDIR /app

# 5. 复制项目文件
COPY . .

# 6. 修复 `/app` 目录的权限
RUN chmod -R 777 /app

# 7. 让 Git 允许 Flutter 目录
RUN git config --global --add safe.directory /opt/flutter

# 8. 获取 Flutter 依赖
RUN flutter pub get

# 9. 构建 Flutter Web 应用
RUN flutter build web

# 10. 使用 Nginx 提供 Web 服务器
FROM nginx:alpine

# 11. 复制 Flutter Web 构建后的文件到 Nginx 目录
COPY --from=builder /app/build/web /usr/share/nginx/html

# 12. 公开 80 端口
EXPOSE 80

# 13. 启动 Nginx 服务器
CMD ["nginx", "-g", "daemon off;"]
