@echo off
REM dcrestart.bat

echo Deteniendo y limpiando todos los servicios de Docker Compose...
docker compose down -v --remove-orphans

if %errorlevel% equ 0 (
    echo Reconstruyendo y levantando los servicios de Docker Compose...
    docker compose up -d --build
    if %errorlevel% equ 0 (
        echo Docker Compose ha sido reiniciado con exito.
    ) else (
        echo Error al levantar los servicios de Docker Compose.
        exit /b 1
    )
) else (
    echo Error al detener y limpiar los servicios de Docker Compose.
    exit /b 1
) 