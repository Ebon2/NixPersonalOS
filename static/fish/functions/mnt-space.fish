function mnt-space --description="Ver espacio del servidor"
    if mountpoint -q ~/Servidor
        df -h ~/Servidor
    else
        echo "✗ No montado"
    end
end
