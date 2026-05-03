function Nix_Init_Labs
    set languajes jvm cpp python network reversing debug web go rust

    set flake_path ~/labs
    
    for l in $languajes
        nix develop "$flake_path#$l" \
            --profile $flake_path/.profiles/$l \
            --command echo "The $l laboratory as ready to use"
    end
end
