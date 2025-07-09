@echo off
echo Iniciando la configuración de los submódulos (Batch)...

REM Inicializar y actualizar los submódulos
echo Clonando o actualizando los submódulos...
git submodule update --init --recursive --remote --merge

REM Submódulo a excluir
set "EXCLUDE_MODULE=nutripae-observabilidad"

echo Copiando .env.example a .env en los submódulos necesarios...

REM Obtener las rutas de los submódulos desde .gitmodules
for /f "tokens=2 delims= " %%A in ('git config --file .gitmodules --get-regexp submodule.^..*^.path') do (
    set "SUBMODULE_PATH=%%A"
    call :process_submodule
)

echo Configuración de submódulos completada (Batch).
goto :eof

:process_submodule
REM Extraer nombre del submódulo desde la ruta
for %%B in ("%SUBMODULE_PATH%") do set "SUBMODULE_NAME=%%~nxB"

if /i "%SUBMODULE_NAME%"=="%EXCLUDE_MODULE%" (
    echo   - Omitiendo %SUBMODULE_NAME% (observabilidad) para la copia de .env.
    goto :eof
)

set "ENV_EXAMPLE_PATH=%SUBMODULE_PATH%\.env.example"
set "ENV_PATH=%SUBMODULE_PATH%\.env"

if exist "%ENV_EXAMPLE_PATH%" (
    if not exist "%ENV_PATH%" (
        copy "%ENV_EXAMPLE_PATH%" "%ENV_PATH%" >nul
        echo   - Copiado %ENV_EXAMPLE_PATH% a %ENV_PATH%
    ) else (
        echo   - %ENV_PATH% ya existe en %SUBMODULE_NAME%, omitiendo copia.
    )
) else (
    echo   - Advertencia: %ENV_EXAMPLE_PATH% no encontrado en %SUBMODULE_NAME%.
)
goto :eof
