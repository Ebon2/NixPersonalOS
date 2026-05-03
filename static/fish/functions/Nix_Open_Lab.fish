function Nix_Open_Lab
    # Evitar autocompletar archivos
    complete -c Nix_Open_Lab -f

    # ===== Subcomandos principales =====
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "jvm" -d "Laboratorio Java / Kotlin"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "cpp" -d "Laboratorio C / C++"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "python" -d "Laboratorio Python"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "network" -d "Laboratorio de redes"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "reversing" -d "Ingeniería inversa"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "debug" -d "Debugging"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "web" -d "Desarrollo web"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "go" -d "Laboratorio Go"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "rust" -d "Laboratorio Rust"

    # ===== Aliases (porque te gusta escribir cosas distintas cada vez) =====
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "java kt" -d "Alias para JVM"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "c c++" -d "Alias para C/C++"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "py" -d "Alias para Python"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "nw" -d "Alias para Network"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "re" -d "Alias para Reversing"
    complete -c Nix_Open_Lab -n "__fish_use_subcommand" -a "db" -d "Alias para Debug"

    # ===== Segundo argumento (programa) =====
    complete -c Nix_Open_Lab \
    -n "__fish_seen_subcommand_from jvm java kt cpp c c++ python py network nw reversing re debug db web go rust" \
    -a "code nvim vim nano" \
    -d "Programa para abrir el lab"

    set name NONE
    if set -q argv[1]
        set name (string lower $argv[1])
    end
    
    set program code 
    if set -q argv[2] 
        set program $argv[2]
    end
     
    set shell_path ~/labs/.profiles
    set lab_path ~/labs

    set OPEN_TERMINAL none 0 terminal
    
    set JAVA java jvm kt
    set CPP cpp c++ c
    set PY py python
    set NW nw network
    set RE re reversing
    set DB db debug
    set WEB web
    set GO go
    set RS rs rust
    
    switch $name
        case $JAVA
            set languaje jvm
        case $CPP
            set languaje cpp
        case $PY
            set languaje python
        case $NW
            set languaje network
        case $RE
            set languaje reversing
        case $DB
            set languaje debug
        case $WEB
            set languaje web
        case $GO
            set languaje go
        case $RS
            set languaje rust

        case '*'
            echo "Comando invalido"
            echo "===== Posibles comandos ===== "
            echo " - JVM $JAVA"
            echo " - CPP $CPP"
            echo " - PY $PY"
            echo " - NETWORK $NW"
            echo " - REVERSING $RE"
            echo " - DEBUG $DB"
            echo " - WEB $WEB"
            echo " - GO $GO"
            echo " - RUST $RS"
            return 1
    end
    
    set base_command nix develop "$lab_path#$languaje" \
        --profile "$shell_path/$languaje"

    switch (string lower $program)
        case $OPEN_TERMINAL
            $base_command
        case '*'
            $base_command -c $program "$lab_path/$languaje"
            exit
    end
end
