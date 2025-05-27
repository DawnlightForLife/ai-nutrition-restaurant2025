#!/bin/bash

# 构建脚本 - 支持多环境和多平台构建

set -e

# 默认值
PLATFORM="android"
FLAVOR="dev"
BUILD_TYPE="debug"

# 解析命令行参数
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -p|--platform) PLATFORM="$2"; shift ;;
        -f|--flavor) FLAVOR="$2"; shift ;;
        -t|--type) BUILD_TYPE="$2"; shift ;;
        -h|--help)
            echo "Usage: ./build.sh [options]"
            echo "Options:"
            echo "  -p, --platform <platform>  Build platform (android|ios|both) [default: android]"
            echo "  -f, --flavor <flavor>      Build flavor (dev|staging|prod) [default: dev]"
            echo "  -t, --type <type>         Build type (debug|release) [default: debug]"
            echo "  -h, --help                Show help"
            exit 0
            ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

# 验证参数
if [[ ! "$PLATFORM" =~ ^(android|ios|both)$ ]]; then
    echo "Error: Invalid platform. Must be android, ios, or both"
    exit 1
fi

if [[ ! "$FLAVOR" =~ ^(dev|staging|prod)$ ]]; then
    echo "Error: Invalid flavor. Must be dev, staging, or prod"
    exit 1
fi

if [[ ! "$BUILD_TYPE" =~ ^(debug|release)$ ]]; then
    echo "Error: Invalid build type. Must be debug or release"
    exit 1
fi

# 设置入口文件
MAIN_FILE="lib/main_${FLAVOR}.dart"

echo "Building $PLATFORM $FLAVOR $BUILD_TYPE..."

# Android 构建
build_android() {
    echo "Building Android APK..."
    
    if [ "$BUILD_TYPE" == "release" ]; then
        flutter build apk --release --flavor "$FLAVOR" -t "$MAIN_FILE"
        echo "APK built at: build/app/outputs/flutter-apk/app-${FLAVOR}-release.apk"
    else
        flutter build apk --debug --flavor "$FLAVOR" -t "$MAIN_FILE"
        echo "APK built at: build/app/outputs/flutter-apk/app-${FLAVOR}-debug.apk"
    fi
}

# iOS 构建
build_ios() {
    echo "Building iOS IPA..."
    
    if [ "$BUILD_TYPE" == "release" ]; then
        flutter build ios --release --flavor "$FLAVOR" -t "$MAIN_FILE"
    else
        flutter build ios --debug --flavor "$FLAVOR" -t "$MAIN_FILE"
    fi
    
    echo "iOS build completed. Use Xcode or Fastlane to export IPA."
}

# 执行构建
case $PLATFORM in
    android)
        build_android
        ;;
    ios)
        build_ios
        ;;
    both)
        build_android
        build_ios
        ;;
esac

echo "Build completed successfully!"