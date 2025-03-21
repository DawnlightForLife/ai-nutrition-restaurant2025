@echo off
echo 正在启用 Git 全局代理（适配 Clash 默认 HTTP 端口 7890）...
git config --global http.proxy http://127.0.0.1:7890
git config --global https.proxy http://127.0.0.1:7890
echo ✅ Git 代理已启用！
pause
