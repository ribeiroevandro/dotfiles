function initProject_setup -d "Assistente de configuração do initProject"
    echo "Bem-vindo ao assistente de configuração do initProject!"

    # 1. Initialize config directory
    set -l config_output (_initProject_setup_init_config_dir)
    set -l config_dir $config_output[1]
    set -l config_file $config_output[2]
    set -l _initProject_all_profiles

    # 2. Setup Git/GitHub Integration
    read -P "Deseja integrar com o Git e GitHub? (s/N) " use_git
    set -l use_git_bool false
    if test "$use_git" = "s"
        set use_git_bool true
    end

    set -l github_user ""
    if $use_git_bool
        _initProject_setup_check_gh_cli
        _initProject_exit_on_error "Falha na verificação do GitHub CLI."
        _initProject_setup_authenticate_github
        _initProject_exit_on_error "Falha na autenticação do GitHub."
        set github_user (_initProject_setup_get_github_user)
    end

    # 3. Setup Base Path
    set -l expanded_base_path (_initProject_setup_get_base_path)
    _initProject_exit_on_error "Falha ao obter o caminho base."

    # 4. Write Config Header
    echo "DEBUG: config_dir = '$config_dir'"
    echo "DEBUG: config_file = '$config_file'"
    echo "DEBUG: expanded_base_path = '$expanded_base_path'"
    _initProject_setup_write_config_header $config_file $use_git_bool $github_user $expanded_base_path

    # New: Initialize _initProject_all_profiles
    set -l _initProject_all_profiles # Initialize here

    # 5. Loop for Profiles
    while true
        set -l profile_output_raw (_initProject_setup_configure_profile $use_git_bool $expanded_base_path)
        _initProject_exit_on_error "Falha ao configurar o perfil."

        set -l parts (string split -- "---PROFILE_CONTENT_START---" -- $profile_output_raw)
        set -l current_profile_name (echo $parts[1] | string trim)
        set -l current_profile_content (echo $parts[2] | string trim)

        set -a _initProject_all_profiles $current_profile_name
        echo -e "$current_profile_content" >> $config_file

        read -P "Deseja adicionar outro perfil? (s/N) " add_another
        if test "$add_another" != "s"
            break
        end
    end

    # 6. Write Profiles List (Moved here)
    _initProject_setup_write_profiles_list $config_file $_initProject_all_profiles

    # 7. Final Message
    echo "Configuração salva com sucesso em $config_file!"
end
