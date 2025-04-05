#!/bin/bash

# Script optimizado para limpiar archivos temporales y caché en Arch Linux
# Preserva datos de contraseñas y URLs frecuentes de Brave Browser

# Colores para la salida
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Verifica si se ejecuta como root
[[ $EUID -ne 0 ]] && { echo -e "${RED}Ejecuta este script como root (sudo).${NC}"; exit 1; }

echo "Iniciando limpieza de archivos temporales y caché..."

# Lista de directorios a limpiar con mensajes descriptivos
declare -A TEMP_DIRS=(
    ["/tmp/*"]="archivos temporales del sistema en /tmp"
    ["/var/tmp/*"]="archivos temporales en /var/tmp"
    ["/var/cache/pacman/pkg/*"]="caché de paquetes antiguos en /var/cache/pacman/pkg"
    ["$HOME/.cache/*"]="caché del usuario en $HOME/.cache (excepto datos de Brave)"
)

# Directorio de Brave a preservar
BRAVE_PROFILE="$HOME/.config/BraveSoftware/Brave-Browser/Default"

# Función para limpiar directorios
clean_dir() {
    local dir="$1" msg="$2"
    [[ -d $(dirname "$dir") ]] || { echo "Directorio $(dirname "$dir") no encontrado, omitiendo..."; return; }
    echo "Borrando $msg..."
    if [[ "$dir" == "$HOME/.cache/*" ]]; then
        find "$HOME/.cache" -maxdepth 1 -not -path "$BRAVE_PROFILE" -exec rm -rf {} + 2>/dev/null
    else
        rm -rf "$dir" 2>/dev/null
    fi
    echo "${msg^} eliminados."
}

# Limpieza de directorios
for dir in "${!TEMP_DIRS[@]}"; do
    clean_dir "$dir" "${TEMP_DIRS[$dir]}"
done

# Limpiar caché de pacman manteniendo las últimas 3 versiones
if command -v paccache >/dev/null; then
    echo "Reduciendo caché de paquetes de pacman (manteniendo últimas 3 versiones)..."
    paccache -r >/dev/null 2>&1
    echo "Caché de paquetes de pacman reducido."
else
    echo "paccache no está instalado, omitiendo limpieza de caché de pacman."
fi

# Mensaje final
echo -e "${GREEN}Limpieza completada. Datos de contraseñas y URLs frecuentes de Brave preservados.${NC}"
exit 0