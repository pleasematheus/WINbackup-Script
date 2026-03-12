@echo off
set "LEVEL=%~1"
set "MSG=%~2"
echo [%date% %time%] [%LEVEL%] %MSG% >> "%LOG_FILE%"
exit /b 0