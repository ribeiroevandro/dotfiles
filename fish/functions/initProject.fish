# functions/initProject.fish

function initProject -d "Cria um novo projeto com base nas configurações do initProject"
    echo "DEBUG: initProject function started." >&2

    # Carregar a configuração
    if not load_initProject_config
        echo "DEBUG: initProject failed at load_initProject_config." >&2
        echo "Erro: Não foi possível carregar a configuração do initProject." >&2
        return 1
    end

    # Argumentos:
    # $argv[1]: Nome do perfil (ex: pessoal, trabalho)
    # $argv[2]: Nome do projeto (ex: meu-app, site-cliente)

    if test (count $argv) -lt 2
        echo "Uso: initProject <perfil> <nome_do_projeto>" >&2
        echo "Perfis disponíveis: "(get_initProject_config "initProject.profiles") >&2
        return 1
    end

    set -l profile_name $argv[1]
    set -l project_name $argv[2]

    if not contains $profile_name (get_initProject_config "initProject.profiles")
        echo "Erro: Perfil '$profile_name' não encontrado." >&2
        echo "Perfis disponíveis: "(get_initProject_config "initProject.profiles") >&2
        return 1
    end

    # Obter configurações do perfil
    set -l base_path (get_initProject_config "initProject.base_path")
    set -l profile_path (get_initProject_config "initProject.profile.$profile_name.path")
    set -l org (get_initProject_config "initProject.profile.$profile_name.org")
    set -l create_remote_repo (get_initProject_config "initProject.profile.$profile_name.create_remote_repo")
    set -l repo_name (get_initProject_config "initProject.profile.$profile_name.repo_name")

    # Construir caminho local completo
    set -l full_local_path "$base_path/$profile_path/$project_name"

    echo "DEBUG: base_path = '$base_path'" >&2
    echo "DEBUG: profile_path = '$profile_path'" >&2
    echo "DEBUG: project_name = '$project_name'" >&2
    echo "DEBUG: full_local_path = '$full_local_path'" >&2

    echo "Criando diretório local: $full_local_path"
    mkdir -p "$full_local_path"

    if test $status -ne 0
        echo "DEBUG: initProject failed at mkdir -p '$full_local_path'." >&2
        echo "Erro ao criar diretório local: $full_local_path" >&2
        return 1
    end

    # Clonar repositório remoto, se aplicável
    if test "$create_remote_repo" = "true"
        set -l github_user (get_initProject_config "initProject.github_user")
        set -l final_repo_name

        # Se repo_name não estiver definido no perfil, usar project_name
        if test -z "$repo_name"
            set final_repo_name $project_name
        else
            set final_repo_name $repo_name
        end

        set -l full_repo_path "$org/$final_repo_name"

        echo "Verificando repositório remoto: $full_repo_path"
        if gh repo view "$full_repo_path" &> /dev/null
            echo "Repositório remoto '$full_repo_path' já existe. Clonando..."
            # Ensure the target directory exists
            mkdir -p "$full_local_path"

            # Clone the repository directly into the full_local_path
            if gh repo clone "$full_repo_path" "$full_local_path"
                echo "Repositório clonado com sucesso em '$full_local_path'."
            else
                echo "DEBUG: initProject failed at gh repo clone '$full_repo_path'." >&2
                echo "Erro ao clonar repositório '$full_repo_path'. Verifique se o diretório já existe e não está vazio." >&2
                return 1
            end
        else
            echo "Repositório remoto '$full_repo_path' não existe. Não será clonado."
        end
    else
        echo "Criação de repositório remoto não habilitada para o perfil '$profile_name'."
    end

    echo "Projeto '$project_name' criado com sucesso em '$full_local_path'."

    # Final Debug Summary
    echo "DEBUG SUMMARY:" >&2
    echo "  Profile Name: '$profile_name'" >&2
    echo "  Project Name: '$project_name'" >&2
    echo "  Base Path: '$base_path'" >&2
    echo "  Profile Path: '$profile_path'" >&2
    echo "  Full Local Path (Target): '$full_local_path'" >&2
    echo "  Remote Repo Org: '$org'" >&2
    echo "  Remote Repo Name: '$final_repo_name'" >&2
    echo "  Create Remote Repo: '$create_remote_repo'" >&2
    echo "  Cloned Successfully: (Check previous messages)" >&2 # Cannot directly check here without more state
end
