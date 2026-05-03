function WCompile --description="Cross-compilar .c/.cpp para Windows"
    if test (count $argv) -ne 2
        echo "Uso: WCompile input.(c|cpp) output.exe"
        return 1
    end
    set input $argv[1]
    set output $argv[2]
    if not test -f $input
        echo "Error: archivo '$input' no existe"
        return 1
    end
    switch $input
        case "*.c"
            set compiler x86_64-w64-mingw32-gcc
            set flags -O2 -static -static-libgcc
        case "*.cpp" "*.cc" "*.cxx"
            set compiler x86_64-w64-mingw32-g++
            set flags -O2 -static -static-libgcc -static-libstdc++
        case "*"
            echo "Error: extensión no soportada"
            return 1
    end
    echo "Compilando $input → $output (Windows, static)"
    $compiler $input $flags -o $output
end
