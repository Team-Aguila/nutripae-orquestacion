#!/bin/bash

# dcrestart.sh

function dcrestart() {
    echo "Deteniendo y limpiando todos los servicios de Docker Compose..."
    docker compose down -v --remove-orphans

    if [ $? -eq 0 ]; then
        echo "Reconstruyendo y levantando los servicios de Docker Compose..."
        docker compose up -d --build
        if [ $? -eq 0 ]; then
            echo "Docker Compose ha sido reiniciado con éxito."
        else
            echo "Error al levantar los servicios de Docker Compose."
            return 1
        fi
    else
        echo "Error al detener y limpiar los servicios de Docker Compose."
        return 1
    fi
}

dcrestart 