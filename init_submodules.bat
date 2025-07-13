@echo off
setlocal enabledelayedexpansion
echo Iniciando la configuración de los submódulos (Batch)...

REM Inicializar y actualizar los submódulos
echo Clonando o actualizando los submódulos...
git submodule update --init --recursive --remote --merge

REM Submódulo a excluir
set "EXCLUDE_MODULE=nutripae-observabilidad"

echo Copiando .env.example a .env en los submódulos necesarios...

REM Procesar directamente la salida de git config (método más simple)
for /f "tokens=2 delims= " %%A in ('git config --file .gitmodules --get-regexp "submodule\..*\.path"') do (
    
    REM Extraer nombre del submódulo desde la ruta
    for %%B in ("%%A") do set "SUBMODULE_NAME=%%~nxB"
    
    REM Verificar si no es el módulo a excluir
    if not "!SUBMODULE_NAME!"=="!EXCLUDE_MODULE!" (
        
        if exist "%%A\.env.example" (
            if not exist "%%A\.env" (
                copy "%%A\.env.example" "%%A\.env" >nul
                echo   - Copiado %%A\.env.example a %%A\.env
            ) else (
                echo   - %%A\.env ya existe, omitiendo copia.
            )
        ) else (
            echo   - Advertencia: %%A\.env.example no encontrado.
        )
    ) else (
        echo   - Omitiendo !SUBMODULE_NAME! (observabilidad) para la copia de .env.
    )
)

echo Configuración de submódulos completada (Batch).
