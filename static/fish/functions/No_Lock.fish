function No_Lock --description="Bloquear suspensión por inactividad"
    echo "Bloqueando suspensión por inactividad..."
    systemd-inhibit --what=idle:sleep \
        --who="No Lock" \
        --why="Suspensión temporal desactivada por el usuario" \
        sleep infinity &
    set inhibitor_pid $last_pid
    echo ""
    echo "Suspensión congelada. Escribe 'q' para restaurar."
    while true
        read -l input
        if test "$input" = q
            break
        end
    end
    echo "Restaurando comportamiento normal..."
    kill $inhibitor_pid
    echo "Listo."
end
