@echo off
cd /d %~dp0

:: 获取当前时间戳
for /f %%i in ('powershell -Command "Get-Date -Format yyyy-MM-dd_HH-mm-ss"') do set datetime=%%i

:: 提示提交说明
set /p message=请输入提交说明（默认：自动提交）：

if "%message%"=="" (
    set message=自动提交_%datetime%
) else (
    set message=%message%_%datetime%
)

git add .
git commit -m "%message%"
git push origin main

pause
