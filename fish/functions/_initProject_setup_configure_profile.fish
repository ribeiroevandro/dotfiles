function _initProject_setup_configure_profile --argument use_git_bool expanded_base_path
    read -P "Nome do perfil (ex: pessoal, trabalho): " profile_name
    read -P "Diretório para este perfil (relativo a $expanded_base_path): " profile_path

    # Criar o diretório do perfil
    mkdir -p "$expanded_base_path/$profile_path"

    set -l profile_content "# Configurações do perfil: $profile_name\n"
    set profile_content "$profile_content""set -g initProject.profile.$profile_name.path \"$profile_path\"
"

    set -l github_owner ""
    set -l repo_name ""
    set -l create_remote_repo_flag false

    if test "$use_git_bool" = "true"
        # Obter o usuário logado e as organizações
        set -l gh_auth_output (gh auth status -h github.com)
        set -l logged_in_user (echo $gh_auth_output | string match -r 'Logged in as (\w+)' | string replace -r '$1' '')
        set -l gh_org_output (gh org list --limit 999)
        set -l orgs
        for line in $gh_org_output
            if not string match -q --regex "^NAME" "$line" # Skip header line
                set -a orgs (echo $line | awk '{print $1}')
            end
        end
        set -l choices $logged_in_user $orgs

        echo > /dev/tty
        echo "Selecione onde o repositório será criado:" > /dev/tty
        for i in (seq (count $choices))
            echo "  $i. $choices[$i]" > /dev/tty
        end

        read -P "Escolha uma opção (ou pressione Enter para pular): " choice_index
        if test -n "$choice_index" -a "$choice_index" -ge 1 -a "$choice_index" -le (count $choices)
            set github_owner $choices[$choice_index]
            set profile_content "$profile_content""set -g initProject.profile.$profile_name.org \"$github_owner\"
"

            echo "Você selecionou '$github_owner' como proprietário do repositório." > /dev/tty # Placeholder for new logic
            read -P "Qual o nome do repositório GitHub que deseja criar (padrão: $profile_name)? " repo_name_input
            if test -z "$repo_name_input"
                set repo_name $profile_name
            else
                set repo_name $repo_name_input
            end

            set -l full_repo_name "$github_owner/$repo_name"
            echo "Verificando se o repositório '$full_repo_name' já existe..." > /dev/tty

            if gh repo view "$full_repo_name" &> /dev/null
                echo "O repositório '$full_repo_name' já existe. Não será criado um novo." > /dev/tty
                set create_remote_repo_flag false
            else
                read -P "O repositório '$full_repo_name' não existe. Deseja criá-lo agora (privado)? (s/N) " confirm_create_repo
                if test "$confirm_create_repo" = "s"
                    echo "Criando repositório '$full_repo_name'" > /dev/tty
                    if gh repo create "$full_repo_name" --private > /dev/null
                        echo "Repositório '$full_repo_name' criado com sucesso!" > /dev/tty
                        set create_remote_repo_flag true
                    else
                        echo "Falha ao criar o repositório '$full_repo_name'." > /dev/tty
                        set create_remote_repo_flag false
                    end
                else
                    echo "Criação do repositório cancelada." > /dev/tty
                    set create_remote_repo_flag false
                end
            end
        else
            echo "Nenhuma organização/perfil selecionado para este perfil. A criação de repositório remoto será ignorada." > /dev/tty
            set create_remote_repo_flag false
        end
    end

    set profile_content "$profile_content""set -g initProject.profile.$profile_name.create_remote_repo $create_remote_repo_flag
"
    set profile_content "$profile_content""set -g initProject.profile.$profile_name.repo_name \"$repo_name\"
"

    printf "%s\n---PROFILE_CONTENT_START---\n%s" "$profile_name" "$profile_content" # Return profile_name and profile_content with a delimiter
end
