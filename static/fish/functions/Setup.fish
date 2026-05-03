function Setup --description="Lanzar entorno de trabajo (cava + clock + spotify)"
    if not pgrep -x cava >/dev/null
        kitty --class cava-term -e cava & disown
    end
    if not pgrep -x tty-clock >/dev/null
        kitty --class clock-term -e tty-clock -c green & disown
    end
    if not pgrep Spotify >/dev/null
        spotify-launcher & disown
    end
    exit
end
