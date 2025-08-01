# ~/.config/fish/functions/eas/is_path_in_projects.fish
# Função auxiliar para verificar se o caminho atual está em algum dos projetos listados

function is_path_in_projects --description "Verifica se o caminho atual está em algum dos projetos listados"
    # Verifica se ao menos dois parâmetros foram fornecidos (caminho base e pelo menos um projeto)
    if test (count $argv) -lt 2
        return 1 # Falso: parâmetros insuficientes
    end

    set base_path $argv[1]
    set -e argv[1]  # Remove o primeiro argumento (base_path) da lista
    set projects $argv  # Os argumentos restantes são os projetos
    set current_path (pwd)
    
    for project in $projects
        set full_project_path "$base_path/$project"
        if string match -q "$full_project_path*" "$current_path"
            return 0 # Verdadeiro: corresponde a um projeto da lista
        end
    end
    
    return 1 # Falso: não corresponde a nenhum projeto
end