@echo off
setlocal
set "SOURCE_DIR=%~1"
set "DEST_ZIP=%~2"

call "%BACKEND_DIR%\core_logger.bat" "INFO" "Iniciando compressao de %SOURCE_DIR% para %DEST_ZIP%"
powershell -NoProfile -Command "Compress-Archive -Path '%SOURCE_DIR%\*' -DestinationPath '%DEST_ZIP%' -Force" >nul 2>&1

if %errorlevel% neq 0 (
    call "%BACKEND_DIR%\core_logger.bat" "ERRO" "Falha ao comprimir %SOURCE_DIR%"
    exit /b 1
)

call "%BACKEND_DIR%\core_logger.bat" "INFO" "Compressao finalizada com sucesso."
endlocal
exit /b 0