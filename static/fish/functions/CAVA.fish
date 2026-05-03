function CAVA --description="Abrir cava en nueva ventana kitty"
    kitty --class cava-term -e cava & disown 2>/dev/null
    exit 0
end
