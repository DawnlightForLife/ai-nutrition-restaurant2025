@echo off
echo 正在关闭 Git 全局代理设置...
git config --global --unset http.proxy
git config --global --unset https.proxy
echo ❎ Git 代理已关闭！
pause
