#!/usr/bin/env fish

# dcrestart.fish

function dcrestart --description "Detiene, limpia y reinicia los servicios de Docker Compose."
    echo "Deteniendo y limpiando todos los servicios de Docker Compose..."
    docker compose down -v --remove-orphans

    if test $status -eq 0
        echo "Reconstruyendo y levantando los servicios de Docker Compose..."
        docker compose up -d --build
        if test $status -eq 0
            echo "Docker Compose ha sido reiniciado con éxito."
        else
            echo "Error al levantar los servicios de Docker Compose."
            return 1
        end
    else
        echo "Error al detener y limpiar los servicios de Docker Compose."
        return 1
    end
end

dcrestart