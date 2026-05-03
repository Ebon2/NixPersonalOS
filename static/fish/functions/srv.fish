function srv --description="Navegar al servidor montado"
    if mountpoint -q ~/Servidor
        cd ~/Servidor
        ls -lah
    else
        echo "✗ Primero monta con: mnt"
    end
end
