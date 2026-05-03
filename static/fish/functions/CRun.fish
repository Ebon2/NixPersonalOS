function CRun --description="Compilar y ejecutar un archivo .c"
    if test (count $argv) -ne 1
        echo "Uso: CRun archivo.c"
        return 1
    end
    set src $argv[1]
    if not test -f $src
        echo "Error: el archivo '$src' no existe"
        return 1
    end
    set exe (basename $src .c)
    gcc $src -o $exe -lm
    if test $status -ne 0
        echo "Error en la compilación"
        return 1
    end
    echo "Ejecutando $exe..."
    ./$exe
    rm -f $exe
end
