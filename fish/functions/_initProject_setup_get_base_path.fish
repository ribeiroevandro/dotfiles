function _initProject_setup_get_base_path
    read -P "Qual é o caminho base para seus projetos? (ex: ~/workspace/github) " base_path
    # Se o caminho não for absoluto e não começar com ~, prefixar com ~/
    if not string match -q --regex "^/" "$base_path"
        and not string match -q --regex "^~" "$base_path"
        set base_path "~/$base_path"
    end
    # Expande o caminho (ex: ~ para /home/user) para uma verificação e armazenamento consistentes
    set -l expanded_base_path (eval echo "$base_path")

    if not test -d "$expanded_base_path"
        echo "O diretório '$expanded_base_path' não existe."
        read -P "Deseja criá-lo agora? (s/N) " create_dir
        if test "$create_dir" = "s"
            mkdir -p "$expanded_base_path"
            echo "Diretório criado em '$expanded_base_path'."
        else
            echo "Operação cancelada. O diretório base é necessário."
            return 1
        end
    end
    echo $expanded_base_path
end