@echo off
setlocal
set "ACAO=%~1"
set "DEST_OR_SRC=%~2"

if "%ACAO%"=="BACKUP" (
    set "TEMP_DIR=%TEMP%\winchester_drivers_temp"
    if exist "!TEMP_DIR!" rd /s /q "!TEMP_DIR!"
    mkdir "!TEMP_DIR!"
    
    call "%BACKEND_DIR%\core_logger.bat" "INFO" "Extraindo drivers (DISM) para diretorio temporario."
    dism /online /export-driver /destination:"!TEMP_DIR!" >nul 2>&1
    if errorlevel 1 (
        call "%BACKEND_DIR%\core_logger.bat" "ERRO" "Falha na exportacao DISM."
        exit /b 1
    )
    
    call "%BACKEND_DIR%\core_compress.bat" "!TEMP_DIR!" "%DEST_OR_SRC%"
    if errorlevel 1 exit /b 1
    
    rd /s /q "!TEMP_DIR!"
    call "%BACKEND_DIR%\core_logger.bat" "INFO" "Pacote de drivers gerado em %DEST_OR_SRC%"
    exit /b 0
)

if "%ACAO%"=="RESTORE" (
    call "%BACKEND_DIR%\core_logger.bat" "INFO" "Restaurando drivers inf a partir de %DEST_OR_SRC%"
    for /r "%DEST_OR_SRC%" %%f in (*.inf) do (
        pnputil /add-driver "%%f" /install >nul 2>&1
    )
    call "%BACKEND_DIR%\core_logger.bat" "INFO" "Restauracao de drivers finalizada."
    exit /b 0
)

endlocal
exit /b 1