@echo off
chcp 65001 >nul
cd /d %~dp0

:: 获取当前 Git 分支名
for /f "delims=" %%i in ('git rev-parse --abbrev-ref HEAD') do set "branch=%%i"

:: 获取时间戳
for /f %%i in ('powershell -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set datetime=%%i

:: 提示输入提交信息
set /p message=请输入提交说明（默认：自动提交）：

if "%message%"=="" (
    set message=自动提交
)

:: 显示状态
echo.
echo 📝 当前分支：%branch%
echo 🕒 提交信息：%message%_%datetime%
echo.

:: 添加所有更改
git add .

:: 提交
git commit -m "%message%_%datetime%"

:: 推送（自动推送当前分支）
git push origin %branch%

:: 保持窗口，显示结果
echo.
pause
