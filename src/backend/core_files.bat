@echo off
setlocal
set "DEST=%~1"
set "bDoc=%~2"
set "bImg=%~3"
set "bMus=%~4"
set "bVid=%~5"
set "bDwn=%~6"
set "bDsk=%~7"
set "GLOBAL_ERROR=0"

call "%BACKEND_DIR%\core_logger.bat" "INFO" "Iniciando operacao de transferencia de arquivos para %DEST%"

if "%bDoc%"=="1" (
    robocopy "%USERPROFILE%\Documents" "%DEST%\Documentos" %ROBOCOPY_FLAGS% >nul
    if errorlevel 8 set "GLOBAL_ERROR=1"
)
if "%bImg%"=="1" (
    robocopy "%USERPROFILE%\Pictures" "%DEST%\Imagens" %ROBOCOPY_FLAGS% >nul
    if errorlevel 8 set "GLOBAL_ERROR=1"
)
if "%bMus%"=="1" (
    robocopy "%USERPROFILE%\Music" "%DEST%\Musicas" %ROBOCOPY_FLAGS% >nul
    if errorlevel 8 set "GLOBAL_ERROR=1"
)
if "%bVid%"=="1" (
    robocopy "%USERPROFILE%\Videos" "%DEST%\Videos" %ROBOCOPY_FLAGS% >nul
    if errorlevel 8 set "GLOBAL_ERROR=1"
)
if "%bDwn%"=="1" (
    robocopy "%USERPROFILE%\Downloads" "%DEST%\Downloads" %ROBOCOPY_FLAGS% >nul
    if errorlevel 8 set "GLOBAL_ERROR=1"
)
if "%bDsk%"=="1" (
    robocopy "%USERPROFILE%\Desktop" "%DEST%\Desktop" %ROBOCOPY_FLAGS% >nul
    if errorlevel 8 set "GLOBAL_ERROR=1"
)

call "%BACKEND_DIR%\core_logger.bat" "INFO" "Transferencia de arquivos concluida. Status de Erro: %GLOBAL_ERROR%"
endlocal
exit /b %GLOBAL_ERROR%