#!/bin/bash

# Gradle依赖修复脚本

echo "🔧 修复Gradle依赖问题"
echo "=========================="

# 1. 确保代理环境变量设置
echo "📡 设置代理环境..."
export HTTP_PROXY="http://127.0.0.1:1082"
export HTTPS_PROXY="http://127.0.0.1:1082"
export ALL_PROXY="socks5://127.0.0.1:1082"
export NO_PROXY="localhost,127.0.0.1,::1"

# 2. 创建或更新全局Gradle配置
echo "⚙️ 配置全局Gradle代理..."
mkdir -p ~/.gradle
cat > ~/.gradle/gradle.properties << 'EOF'
# Gradle代理配置
systemProp.http.proxyHost=127.0.0.1
systemProp.http.proxyPort=1082
systemProp.https.proxyHost=127.0.0.1
systemProp.https.proxyPort=1082
systemProp.http.nonProxyHosts=*.nonproxyrepos.com|localhost

# 网络优化
systemProp.org.gradle.internal.http.connectionTimeout=120000
systemProp.org.gradle.internal.http.socketTimeout=120000

# JVM内存设置
org.gradle.jvmargs=-Xmx4096m -Dfile.encoding=UTF-8 -Dhttps.protocols=TLSv1.2,TLSv1.3

# 并行构建
org.gradle.parallel=true
org.gradle.daemon=true
org.gradle.caching=true
EOF

# 3. 检查并修复android/build.gradle文件
echo "📝 修复android/build.gradle..."
if [ -f "android/build.gradle" ]; then
    # 备份原文件
    cp android/build.gradle android/build.gradle.backup
    
    # 创建修复的build.gradle
    cat > android/build.gradle.new << 'EOF'
buildscript {
    ext.kotlin_version = '1.9.25'
    repositories {
        // 添加Google官方镜像（优先）
        maven { url 'https://dl.google.com/dl/android/maven2/' }
        google()
        mavenCentral()
        // 备用镜像
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/central' }
        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }
    }

    dependencies {
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
    }
}

allprojects {
    repositories {
        // 添加Google官方镜像（优先）
        maven { url 'https://dl.google.com/dl/android/maven2/' }
        google()
        mavenCentral()
        // 备用镜像
        maven { url 'https://maven.aliyun.com/repository/google' }
        maven { url 'https://maven.aliyun.com/repository/central' }
        maven { url 'https://jitpack.io' }
    }
}

rootProject.buildDir = "../build"
subprojects {
    project.buildDir = "${rootProject.buildDir}/${project.name}"
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register("clean", Delete) {
    delete rootProject.buildDir
}
EOF
    
    # 检查是否已有备份内容
    if grep -q "buildscript" android/build.gradle; then
        echo "使用现有的build.gradle，添加仓库配置..."
        # 使用sed添加仓库配置
        sed -i '' 's|repositories {|repositories {\
        maven { url "https://dl.google.com/dl/android/maven2/" }|g' android/build.gradle
    else
        echo "使用新的build.gradle模板..."
        mv android/build.gradle.new android/build.gradle
    fi
else
    echo "❌ 找不到android/build.gradle文件"
fi

# 4. 清理Gradle缓存
echo "🧹 清理Gradle缓存..."
cd android
./gradlew clean --no-daemon || echo "继续..."
cd ..

# 5. 下载依赖（使用代理）
echo "📦 下载依赖..."
cd android
./gradlew dependencies --refresh-dependencies --no-daemon || echo "继续..."
cd ..

# 6. 测试连接Google Maven仓库
echo "🌐 测试Google Maven仓库连接..."
curl -x http://127.0.0.1:1082 --connect-timeout 10 -I https://dl.google.com/dl/android/maven2/androidx/core/core/1.13.1/core-1.13.1.pom

echo "✅ 修复完成！"
echo "📱 现在尝试运行: flutter run --flavor dev -d emulator-5554"