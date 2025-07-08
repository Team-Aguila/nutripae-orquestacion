#!/bin/bash

echo "Iniciando la configuración de los submódulos (Bash/Zsh)..."

# Inicializar y actualizar los submódulos
echo "Clonando o actualizando los submódulos..."
git submodule update --init --recursive --remote --merge

# Lista de submódulos donde NO queremos copiar .env.example
EXCLUDE_MODULE="nutripae-observabilidad"

# Iterar sobre cada submódulo y copiar .env.example a .env si no existe
echo "Copiando .env.example a .env en los submódulos necesarios..."

# Lee el archivo .gitmodules y procesa cada línea de submódulo
git config --file .gitmodules --get-regexp submodule\..*\.path | while read -r line; do
    # Extrae la ruta del submódulo usando awk (funciona correctamente en Bash/Zsh)
    SUBMODULE_PATH=$(echo "$line" | awk '{print $2}')
    # Extrae solo el nombre del directorio final del submódulo
    SUBMODULE_NAME=$(basename "$SUBMODULE_PATH")

    # Verifica si el submódulo actual no es el de exclusión
    if [ "$SUBMODULE_NAME" != "$EXCLUDE_MODULE" ]; then
        ENV_EXAMPLE_PATH="$SUBMODULE_PATH/.env.example"
        ENV_PATH="$SUBMODULE_PATH/.env"

        # Comprueba si .env.example existe y si .env no existe antes de copiar
        if [ -f "$ENV_EXAMPLE_PATH" ]; then
            if [ ! -f "$ENV_PATH" ]; then
                cp "$ENV_EXAMPLE_PATH" "$ENV_PATH"
                echo "  - Copiado $ENV_EXAMPLE_PATH a $ENV_PATH"
            else
                echo "  - $ENV_PATH ya existe en $SUBMODULE_NAME, omitiendo copia."
            fi
        else
            echo "  - Advertencia: $ENV_EXAMPLE_PATH no encontrado en $SUBMODULE_NAME."
        fi
    else
        echo "  - Omitiendo $SUBMODULE_NAME (observabilidad) para la copia de .env."
    fi
done

echo "Configuración de submódulos completada (Bash/Zsh)."
