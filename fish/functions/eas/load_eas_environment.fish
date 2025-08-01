# ~/.config/fish/functions/eas/load_eas_environment.fish
# Função principal para gerenciar ambiente EAS

# Exibe o nome do usuário destacado em verde
function eas_user_logged --description "Formata o nome do usuário com destaque em verde"
    set_color --bold green
    echo "$argv[1]"
    set_color normal
end

# Exibe mensagem de autenticação em roxo
function eas_auth_message --description "Exibe mensagem de autenticação em roxo"
    set_color magenta
    echo "$argv[1]"
    set_color normal
end

function load_eas_environment --description "Configura o ambiente EAS com base no diretório atual"
    # Verifica se as variáveis necessárias estão definidas
    if not set -q WORK_PROJECTS_ROOT_PATH; or not set -q PERSONAL_PROJECTS_ROOT_PATH
        # Variáveis de ambiente necessárias não estão definidas
        return 1
    end
    
    # Define caminhos completos dos projetos
    set work_projects_root_path "$HOME/$WORK_PROJECTS_ROOT_PATH"
    set personal_projects_root_path "$HOME/$PERSONAL_PROJECTS_ROOT_PATH"
    
    # Converte as strings separadas por vírgula em arrays
    if set -q WORK_PROJECTS_FOLDERS
        set work_projects_folders (string split "," $WORK_PROJECTS_FOLDERS)
    else
        set work_projects_folders ""
    end
    
    if set -q PERSONAL_PROJECTS_FOLDERS
        set personal_projects_folders (string split "," $PERSONAL_PROJECTS_FOLDERS)
    else
        set personal_projects_folders ""
    end
    
    # Obtém o caminho atual
    set current_path (pwd)
    
    # Captura o usuário atual do EAS
    set current_eas_username (eas whoami 2>/dev/null)
    
    # Verifica se está em algum projeto de trabalho
    if is_path_in_projects "$work_projects_root_path" $work_projects_folders
        if not set -q WORK_PROJECTS_EAS_USERNAME; or not set -q WORK_PROJECTS_EAS_PASSWORD
            # Credenciais de trabalho não configuradas
            return 1
        end
        
        if test "$current_eas_username" != "$WORK_PROJECTS_EAS_USERNAME"
            eas logout >/dev/null 2>&1
            login_eas "$WORK_PROJECTS_EAS_USERNAME" "$WORK_PROJECTS_EAS_PASSWORD"
            set current_eas_username (eas whoami 2>/dev/null)
            
            # eas_user_logged "Login com $WORK_PROJECTS_EAS_USERNAME realizado com sucesso!"
        end
    
    # Verifica se está em algum projeto pessoal
    else if is_path_in_projects "$personal_projects_root_path" $personal_projects_folders
        if not set -q PERSONAL_PROJECTS_EAS_USERNAME; or not set -q PERSONAL_PROJECTS_EAS_PASSWORD
            # Credenciais pessoais não configuradas
            return 1
        end
        
        if test "$current_eas_username" != "$PERSONAL_PROJECTS_EAS_USERNAME"
            eas logout >/dev/null 2>&1
            login_eas "$PERSONAL_PROJECTS_EAS_USERNAME" "$PERSONAL_PROJECTS_EAS_PASSWORD"
            set current_eas_username (eas whoami 2>/dev/null)
         
            # eas_user_logged "Login com $PERSONAL_PROJECTS_EAS_USERNAME realizado com sucesso!"
        end
    end
    # Se não estiver em nenhum dos projetos listados, não faz nada
end