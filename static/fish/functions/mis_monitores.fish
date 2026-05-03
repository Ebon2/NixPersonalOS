function mis_monitores --description="Lanzar cava y clock"
    if not pgrep -x cava >/dev/null
        kitty --class cava-term -e cava & disown
    end
    if not pgrep -x tty-clock >/dev/null
        kitty --class clock-term -e tty-clock -c green & disown
    end
    exit
end
