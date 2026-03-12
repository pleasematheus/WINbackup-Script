@echo off
setlocal EnableDelayedExpansion

:: 1. Configuracao de Codificacao de Caracteres (UTF-8)
chcp 65001 >nul

:: 2. Geracao do Caractere de Escape ANSI
for /F "delims=#" %%E in ('"prompt #$E# & for %%a in (1) do rem"') do set "ESC=%%E"
set "C_RESET=%ESC%[0m"
set "C_CYAN=%ESC%[96m"
set "C_GREEN=%ESC%[92m"
set "C_YELLOW=%ESC%[93m"
set "C_RED=%ESC%[91m"
set "C_GRAY=%ESC%[90m"

:: 3. Leitura do Arquivo de Variaveis de Ambiente (system.env)
set "ENV_FILE=%~dp0system.env"
if exist "%ENV_FILE%" (
    for /f "usebackq tokens=1,* delims==" %%A in ("%ENV_FILE%") do (
        set "%%A=%%B"
    )
) else (
    echo %C_RED%[ERRO CRITICO] Arquivo system.env nao encontrado na raiz.%C_RESET%
    pause
    exit /b
)

:: 4. Verificacao de Privilegios Administrativos
fltmc >nul 2>&1
if %errorlevel% neq 0 (
    cls
    echo.
    echo  %C_RED%╔══════════════════════════════════════════════════════════╗%C_RESET%
    echo  %C_RED%║ [ERRO DE ACESSO] A execucao como Administrador e exigida.  ║%C_RESET%
    echo  %C_RED%╚══════════════════════════════════════════════════════════╝%C_RESET%
    pause
    exit /b
)

:: 5. Definicao de Caminhos Absolutos
set "PROJ_ROOT=%~dp0"
set "FRONTEND_DIR=%PROJ_ROOT%src\frontend"
set "BACKEND_DIR=%PROJ_ROOT%src\backend"

:: 6. Configuracao e Inicializacao do Sistema de Logs
for /f "tokens=1-4 delims=/ " %%a in ("%date%") do (set "DD=%%a" & set "MM=%%b" & set "YYYY=%%c")
for /f "tokens=1-3 delims=:., " %%a in ("%time%") do (set "HH=%%a" & set "Min=%%b" & set "SS=%%c")
set "TS=%YYYY%-%MM%-%DD%_%HH%%Min%%SS%"
set "LOG_FILE=%PROJ_ROOT%%LOG_PREFIX%_%TS%.log"

echo [%date% %time%] [SISTEMA] Iniciando %APP_NAME% v%APP_VERSION% > "%LOG_FILE%"

:: 7. Transferencia de Controle para a Camada Front-end
call "%FRONTEND_DIR%\ui_menus.bat"

:: 8. Encerramento Limpo
echo [%date% %time%] [SISTEMA] Processo finalizado com codigo 0. >> "%LOG_FILE%"
exit /b