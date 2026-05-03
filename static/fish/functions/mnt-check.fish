function mnt-check --description="Verificar si Samba está montado"
    if mountpoint -q ~/Servidor
        echo Montado
        mount | grep Servidor
    else
        echo "No montado"
    end
end
