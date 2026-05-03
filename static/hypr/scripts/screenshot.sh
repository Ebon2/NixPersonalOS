#!/usr/bin/env bash

# Verifica si se pasó un argumento (tipo de captura)
# "area" = captura de área seleccionada
# "" = captura completa
if [ "$1" == "area" ]; then
    geometry=$(slurp)
    [ -z "$geometry" ] && exit 0
    grim -g "$geometry" /tmp/screenshot.png
else
    grim /tmp/screenshot.png
fi

# Preguntar qué hacer
action=$(zenity --list --title="Captura de pantalla" \
    --text="¿Qué deseas hacer con la captura?" \
    --radiolist \
    --column "" --column "Acción" \
    TRUE "Copiar al portapapeles" FALSE "Guardar en archivo" FALSE "Cancelar")

case "$action" in
    "Copiar al portapapeles")
        wl-copy < /tmp/screenshot.png
        notify-send "Captura" "Copiada al portapapeles"
        ;;
    "Guardar en archivo")
        filename=$(zenity --file-selection --save --confirm-overwrite --filename="$HOME/Pictures/screenshot.png")
        [ -n "$filename" ] && mv /tmp/screenshot.png "$filename"
        ;;
    "Cancelar")
        rm /tmp/screenshot.png
        ;;
esac
