@echo off

:menuPrincipal
cls
echo.
echo  %C_CYAN%╔══════════════════════════════════════════════════════╗%C_RESET%
echo  %C_CYAN%║           %APP_NAME% v%APP_VERSION%           ║%C_RESET%
echo  %C_CYAN%╚══════════════════════════════════════════════════════╝%C_RESET%
echo.
echo    %C_GRAY%Selecione a infraestrutura alvo:%C_RESET%
echo.
echo    [%C_CYAN%1%C_RESET%] Mapeamento de Arquivos Pessoais
echo    [%C_CYAN%2%C_RESET%] Backup Compactado de Drivers do Sistema
echo    [%C_CYAN%3%C_RESET%] Arquivamento ZIP de Navegadores (Favoritos)
echo.
echo    [%C_RED%0%C_RESET%] Encerrar Sessao
echo.
set /p optMain="  %C_YELLOW%► Comando:%C_RESET% "

if "%optMain%"=="1" goto menuArquivos
if "%optMain%"=="2" goto menuDrivers
if "%optMain%"=="3" goto menuNavegadores
if "%optMain%"=="0" exit /b
goto menuPrincipal

:: ==============================================================
:: UI - MODULO DE ARQUIVOS PESSOAIS
:: ==============================================================
:menuArquivos
cls
echo.
echo  %C_CYAN%[ MODULO DE DADOS PESSOAIS ]%C_RESET%
echo.
echo    [%C_CYAN%C%C_RESET%] Escaneamento e Backup Completo
echo    [%C_CYAN%S%C_RESET%] Selecao Discreta de Diretorios
echo    [%C_RED%0%C_RESET%] Voltar
echo.
set /p optArq="  %C_YELLOW%► Opcao:%C_RESET% "

if /i "%optArq%"=="C" (
    set "sDoc=1" & set "sImg=1" & set "sMus=1"
    set "sVid=1" & set "sDwn=1" & set "sDsk=1"
    goto inputDestinoArquivos
)
if /i "%optArq%"=="S" goto menuSeletivoArquivos
if "%optArq%"=="0" goto menuPrincipal
goto menuArquivos

:menuSeletivoArquivos
cls
echo.
echo  %C_CYAN%[ SELECAO DISCRETA ]%C_RESET%
echo  %C_GRAY%Informe as flags (ex: 1,2,5)%C_RESET%
echo.
echo  [1] Documentos   [4] Videos
echo  [2] Imagens      [5] Downloads
echo  [3] Musicas      [6] Desktop
echo.
set /p selPastas="  %C_YELLOW%► Flags:%C_RESET% "

set "sDoc=0" & set "sImg=0" & set "sMus=0" & set "sVid=0" & set "sDwn=0" & set "sDsk=0"
echo %selPastas% | find "1" >nul && set "sDoc=1"
echo %selPastas% | find "2" >nul && set "sImg=1"
echo %selPastas% | find "3" >nul && set "sMus=1"
echo %selPastas% | find "4" >nul && set "sVid=1"
echo %selPastas% | find "5" >nul && set "sDwn=1"
echo %selPastas% | find "6" >nul && set "sDsk=1"

:inputDestinoArquivos
echo.
set /p destArq="  %C_YELLOW%► Caminho do Repositorio (Ex: D:\Backup):%C_RESET% "
if not exist "%destArq%" (
    echo  %C_RED%[FATAL] Caminho de armazenamento innacessivel.%C_RESET%
    pause
    goto menuArquivos
)

cls
echo.
echo  %C_CYAN%[SISTEMA] Conectando ao Back-end de Arquivos... Aguarde o processamento.%C_RESET%
call "%BACKEND_DIR%\core_files.bat" "%destArq%" "%sDoc%" "%sImg%" "%sMus%" "%sVid%" "%sDwn%" "%sDsk%"

if %errorlevel% equ 0 (
    echo.
    echo  %C_GREEN%[SUCESSO] Sincronizacao de integridade finalizada com exito.%C_RESET%
) else (
    echo.
    echo  %C_RED%[ERRO] A operacao reportou falhas criticas (Permissao de acesso ou Arquivos Travados). Verifique os logs.%C_RESET%
)
pause
goto menuPrincipal

:: ==============================================================
:: UI - MODULO DE DRIVERS (COMPRESSAO ZIP ATIVA)
:: ==============================================================
:menuDrivers
cls
echo.
echo  %C_CYAN%[ INFRAESTRUTURA DE DRIVERS ]%C_RESET%
echo.
echo    [%C_CYAN%1%C_RESET%] Exportar Drivers para formato ZIP
echo    [%C_CYAN%2%C_RESET%] Restaurar a partir de pasta Descompactada (.inf)
echo    [%C_RED%0%C_RESET%] Voltar
echo.
set /p optDrv="  %C_YELLOW%► Opcao:%C_RESET% "

if "%optDrv%"=="1" (
    echo.
    set /p destDrv="  %C_YELLOW%► Destino para armazenar o ZIP:%C_RESET% "
    if exist "!destDrv!" (
        echo  %C_CYAN%[SISTEMA] Processando exportacao e gerando algoritmo ZIP...%C_RESET%
        call "%BACKEND_DIR%\core_drivers.bat" "BACKUP" "!destDrv!\Drivers_Backup.zip"
        if !errorlevel! equ 0 (
            echo  %C_GREEN%[SUCESSO] Pacote ZIP consolidado e salvo em !destDrv!%C_RESET%
        ) else (
            echo  %C_RED%[ERRO] Falha no processamento. A integridade do arquivo não pode ser garantida.%C_RESET%
        )
        pause
    )
    goto menuPrincipal
)
if "%optDrv%"=="2" (
    echo.
    echo  %C_GRAY%Nota: Extraia o arquivo ZIP gerado antes da restauracao.%C_RESET%
    set /p srcDrv="  %C_YELLOW%► Caminho da pasta contendo os arquivos .inf extraidos:%C_RESET% "
    if exist "!srcDrv!" (
        echo  %C_CYAN%[SISTEMA] Injetando configuracoes de hardware...%C_RESET%
        call "%BACKEND_DIR%\core_drivers.bat" "RESTORE" "!srcDrv!"
        echo  %C_GREEN%[SUCESSO] Instancias recarregadas.%C_RESET%
        pause
    )
    goto menuPrincipal
)
if "%optDrv%"=="0" goto menuPrincipal
goto menuDrivers

:: ==============================================================
:: UI - MODULO DE NAVEGADORES (COMPRESSAO ZIP ATIVA)
:: ==============================================================
:menuNavegadores
cls
echo.
echo  %C_CYAN%[ ARQUIVAMENTO DE FAVORITOS (ZIP) ]%C_RESET%
echo.
echo    [%C_CYAN%1%C_RESET%] Gerar pacotes ZIP (Edge e Chrome)
echo    [%C_RED%0%C_RESET%] Voltar
echo.
set /p optNav="  %C_YELLOW%► Opcao:%C_RESET% "

if "%optNav%"=="1" (
    echo.
    set /p destNav="  %C_YELLOW%► Diretorio alvo para salvar os arquivos ZIP:%C_RESET% "
    if exist "!destNav!" (
        echo.
        echo  %C_CYAN%[SISTEMA] Solicitando processamento Edge...%C_RESET%
        call "%BACKEND_DIR%\core_browsers.bat" "BACKUP" "Edge" "!destNav!"
        if !errorlevel! equ 0 (echo  %C_GREEN%[OK] Edge compactado com sucesso.%C_RESET%) else if !errorlevel! equ 2 (echo  %C_GRAY%[IGNORE] Edge nao instalado.%C_RESET%) else (echo  %C_RED%[ERRO] Falha na compressao Edge.%C_RESET%)
        
        echo  %C_CYAN%[SISTEMA] Solicitando processamento Chrome...%C_RESET%
        call "%BACKEND_DIR%\core_browsers.bat" "BACKUP" "Chrome" "!destNav!"
        if !errorlevel! equ 0 (echo  %C_GREEN%[OK] Chrome compactado com sucesso.%C_RESET%) else if !errorlevel! equ 2 (echo  %C_GRAY%[IGNORE] Chrome nao instalado.%C_RESET%) else (echo  %C_RED%[ERRO] Falha na compressao Chrome.%C_RESET%)
        
        echo.
        echo  %C_GREEN%[SUCESSO] Rotina de aquivamento finalizada.%C_RESET%
        pause
    )
    goto menuPrincipal
)
if "%optNav%"=="0" goto menuPrincipal
goto menuNavegadores