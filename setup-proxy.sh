#!/bin/bash

# ShadowRocket代理配置脚本
# 作者: Claude Code
# 日期: $(date)

echo "🚀 ShadowRocket代理配置脚本"
echo "=================================="

# 检查ShadowRocket是否运行
if pgrep -f "Shadowrocket" > /dev/null; then
    echo "✅ ShadowRocket正在运行"
else
    echo "❌ ShadowRocket未运行，请先启动ShadowRocket"
    exit 1
fi

# 常见的ShadowRocket端口
COMMON_PORTS=(7890 1080 1087 8080 8888 9000)

# 检测ShadowRocket代理端口
echo "🔍 检测ShadowRocket代理端口..."
PROXY_PORT=""
for port in "${COMMON_PORTS[@]}"; do
    if nc -z 127.0.0.1 $port 2>/dev/null; then
        echo "✅ 发现代理端口: $port"
        PROXY_PORT=$port
        break
    fi
done

if [ -z "$PROXY_PORT" ]; then
    echo "⚠️  未检测到标准代理端口，使用默认端口 7890"
    PROXY_PORT=7890
fi

# 设置环境变量
export HTTP_PROXY="http://127.0.0.1:$PROXY_PORT"
export HTTPS_PROXY="http://127.0.0.1:$PROXY_PORT"
export ALL_PROXY="socks5://127.0.0.1:$PROXY_PORT"
export NO_PROXY="localhost,127.0.0.1,::1"

echo "🔧 设置代理环境变量:"
echo "   HTTP_PROXY=$HTTP_PROXY"
echo "   HTTPS_PROXY=$HTTPS_PROXY"
echo "   ALL_PROXY=$ALL_PROXY"

# 创建或更新 shell 配置文件
SHELL_CONFIG=""
if [ -f ~/.zshrc ]; then
    SHELL_CONFIG=~/.zshrc
elif [ -f ~/.bashrc ]; then
    SHELL_CONFIG=~/.bashrc
elif [ -f ~/.bash_profile ]; then
    SHELL_CONFIG=~/.bash_profile
fi

if [ -n "$SHELL_CONFIG" ]; then
    echo "📝 更新Shell配置文件: $SHELL_CONFIG"
    
    # 备份原配置
    cp "$SHELL_CONFIG" "${SHELL_CONFIG}.backup-$(date +%Y%m%d-%H%M%S)"
    
    # 移除旧的代理设置
    sed -i '' '/# ShadowRocket代理设置/,/# ShadowRocket代理设置结束/d' "$SHELL_CONFIG"
    
    # 添加新的代理设置
    cat >> "$SHELL_CONFIG" << EOF

# ShadowRocket代理设置
export HTTP_PROXY="http://127.0.0.1:$PROXY_PORT"
export HTTPS_PROXY="http://127.0.0.1:$PROXY_PORT"
export ALL_PROXY="socks5://127.0.0.1:$PROXY_PORT"
export NO_PROXY="localhost,127.0.0.1,::1"

# Git代理设置
alias git-proxy-on='git config --global http.proxy http://127.0.0.1:$PROXY_PORT && git config --global https.proxy http://127.0.0.1:$PROXY_PORT'
alias git-proxy-off='git config --global --unset http.proxy && git config --global --unset https.proxy'

# Gradle代理设置
alias gradle-proxy-setup='mkdir -p ~/.gradle && echo "systemProp.http.proxyHost=127.0.0.1" > ~/.gradle/gradle.properties && echo "systemProp.http.proxyPort=$PROXY_PORT" >> ~/.gradle/gradle.properties && echo "systemProp.https.proxyHost=127.0.0.1" >> ~/.gradle/gradle.properties && echo "systemProp.https.proxyPort=$PROXY_PORT" >> ~/.gradle/gradle.properties'

# Flutter/Dart代理设置
alias flutter-proxy-setup='export PUB_HOSTED_URL=https://pub.flutter-io.cn && export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn'
# ShadowRocket代理设置结束
EOF
    
    echo "✅ Shell配置已更新"
else
    echo "⚠️  未找到Shell配置文件"
fi

# 设置Git代理
echo "🔧 配置Git代理..."
git config --global http.proxy "http://127.0.0.1:$PROXY_PORT"
git config --global https.proxy "http://127.0.0.1:$PROXY_PORT"
echo "✅ Git代理已配置"

# 设置Gradle代理
echo "🔧 配置Gradle代理..."
mkdir -p ~/.gradle
cat > ~/.gradle/gradle.properties << EOF
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=$PROXY_PORT
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=$PROXY_PORT
systemProp.http.nonProxyHosts=*.nonproxyrepos.com|localhost
org.gradle.jvmargs=-Dfile.encoding=UTF-8
EOF
echo "✅ Gradle代理已配置"

# 设置Flutter/Dart镜像
echo "🔧 配置Flutter镜像..."
if [ -f ~/.zshrc ]; then
    echo 'export PUB_HOSTED_URL=https://pub.flutter-io.cn' >> ~/.zshrc
    echo 'export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn' >> ~/.zshrc
fi
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
echo "✅ Flutter镜像已配置"

# 测试网络连接
echo "🔍 测试网络连接..."
if curl -s --connect-timeout 5 --proxy "http://127.0.0.1:$PROXY_PORT" https://www.google.com > /dev/null; then
    echo "✅ 代理连接正常"
else
    echo "❌ 代理连接失败，请检查ShadowRocket设置"
fi

# 测试Maven仓库连接
echo "🔍 测试Maven仓库连接..."
if curl -s --connect-timeout 5 --proxy "http://127.0.0.1:$PROXY_PORT" https://dl.google.com/dl/android/maven2/ > /dev/null; then
    echo "✅ Google Maven仓库连接正常"
else
    echo "❌ Google Maven仓库连接失败"
fi

echo ""
echo "🎉 代理配置完成!"
echo "📋 接下来请："
echo "   1. 重启VSCode以应用新的代理设置"
echo "   2. 重新打开终端以加载新的环境变量"
echo "   3. 运行 'source $SHELL_CONFIG' 或重新打开终端"
echo "   4. 在Flutter项目中重新运行 'flutter clean && flutter pub get'"
echo ""
echo "🔧 手动命令（如果需要）："
echo "   • 启用Git代理: git-proxy-on"
echo "   • 关闭Git代理: git-proxy-off"
echo "   • 设置Gradle代理: gradle-proxy-setup"
echo "   • 设置Flutter镜像: flutter-proxy-setup"