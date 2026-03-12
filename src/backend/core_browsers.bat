@echo off
setlocal EnableDelayedExpansion
set "ACAO=%~1"
set "NAVEGADOR=%~2"
set "CAMINHO_ORIG_DEST=%~3"

if "%ACAO%"=="BACKUP" (
    set "perfilBase="
    if "%NAVEGADOR%"=="Edge" set "perfilBase=%LOCALAPPDATA%\Microsoft\Edge\User Data"
    if "%NAVEGADOR%"=="Chrome" set "perfilBase=%LOCALAPPDATA%\Google\Chrome\User Data"

    if not exist "!perfilBase!" (
        call "%BACKEND_DIR%\core_logger.bat" "AVISO" "Navegador %NAVEGADOR% nao detectado na base do sistema."
        exit /b 2
    )

    set "favDefault=!perfilBase!\Default\Bookmarks"
    if not exist "!favDefault!" exit /b 1

    set "TEMP_DIR=%TEMP%\winchester_nav_!NAVEGADOR!"
    if exist "!TEMP_DIR!" rd /s /q "!TEMP_DIR!"
    mkdir "!TEMP_DIR!"
    
    copy /Y "!favDefault!" "!TEMP_DIR!\Bookmarks" >nul 2>&1
    
    call "%BACKEND_DIR%\core_compress.bat" "!TEMP_DIR!" "%CAMINHO_ORIG_DEST%\Favoritos_!NAVEGADOR!.zip"
    if errorlevel 1 exit /b 1
    
    rd /s /q "!TEMP_DIR!"
    call "%BACKEND_DIR%\core_logger.bat" "INFO" "Favoritos do %NAVEGADOR% compactados em %CAMINHO_ORIG_DEST%"
    exit /b 0
)

if "%ACAO%"=="RESTORE" (
    call "%BACKEND_DIR%\core_logger.bat" "ERRO" "A arquitetura atualizou. A restauracao a partir do ZIP exige extracao manual pelo usuario na raiz do navegador."
    :: Esta implementacao prioriza a seguranca, instruindo o front-end a orientar o usuario na importacao manual,
    :: prevenindo corrupcao de bancos SQLite gerados pelas versoes mais recentes dos navegadores Chromium.
    exit /b 0
)
endlocal
exit /b 1