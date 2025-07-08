#!/usr/bin/env fish

echo "Iniciando la configuración de los submódulos (Fish Shell)..."

# Inicializar y actualizar los submódulos
echo "Clonando o actualizando los submódulos..."
git submodule update --init --recursive --remote --merge

# Lista de submódulos donde NO queremos copiar .env.example
set -l EXCLUDE_MODULE "nutripae-observabilidad"

# Iterar sobre cada submódulo y copiar .env.example a .env si no existe
echo "Copiando .env.example a .env en los submódulos necesarios..."

# Obtiene las rutas de los submódulos
git config --file .gitmodules --get-regexp 'submodule\..*\.path' | while read -l line
    # Extrae la ruta del submódulo (el segundo elemento después de dividir por espacio)
    # **¡Corrección aquí! Usamos [2] para obtener el segundo elemento de la lista.**
    set -l parts (echo "$line" | string split " ")
    set -l SUBMODULE_PATH "$parts[2]"

    # Extrae solo el nombre del directorio final del submódulo
    set -l SUBMODULE_NAME (basename "$SUBMODULE_PATH")

    # Verifica si el submódulo actual no es el de exclusión
    if test "$SUBMODULE_NAME" != "$EXCLUDE_MODULE"
        set -l ENV_EXAMPLE_PATH "$SUBMODULE_PATH/.env.example"
        set -l ENV_PATH "$SUBMODULE_PATH/.env"

        # Comprueba si .env.example existe y si .env no existe antes de copiar
        if test -f "$ENV_EXAMPLE_PATH"
            if not test -f "$ENV_PATH"
                cp "$ENV_EXAMPLE_PATH" "$ENV_PATH"
                echo "  - Copiado $ENV_EXAMPLE_PATH a $ENV_PATH"
            else
                echo "  - $ENV_PATH ya existe en $SUBMODULE_NAME, omitiendo copia."
            end
        else
            echo "  - Advertencia: $ENV_EXAMPLE_PATH no encontrado en $SUBMODULE_NAME."
        end
    else
        echo "  - Omitiendo $SUBMODULE_NAME (observabilidad) para la copia de .env."
    end
end

echo "Configuración de submódulos completada (Fish Shell)."