#!/bin/zsh

dotfiles_path="$HOME/${PERSONAL_PROJECTS_ROOT_PATH}/dotfiles"
source "$dotfiles_path/common/messages.sh"
source "$HOME/.eas_credentials"

login_eas() {
    local username="$1"
    local password="$2"
    expo login -u "$username" -p "$password" >/dev/null 2>&1
}

autoload -U add-zsh-hook
load_eas_environment() {
    local current_path="$(pwd)"
    local work_projects_root_path=("${HOME}/${WORK_PROJECTS_ROOT_PATH}")
    local personal_projects_root_path=("${HOME}/${PERSONAL_PROJECTS_ROOT_PATH}")
    local work_projects_folders=(${(s:,:)WORK_PROJECTS_FOLDERS})
    local personal_projects_folders=(${(s:,:)PERSONAL_PROJECTS_FOLDERS})
    local current_eas_username="$(eas whoami 2>/dev/null)"
    

    # Função auxiliar para verificar se o caminho atual está em algum dos projetos listados
    is_path_in_projects() {
        local base_path="$1"
        shift
        local projects=("$@")

        for project in "${projects[@]}"; do
            local full_project_path="${base_path}/${project}"
            if [[ "$current_path" == "$full_project_path"* ]]; then
                return 0 # Verdadeiro: corresponde a um projeto da lista
            fi
        done
        return 1 # Falso: não corresponde
    }

    # Verifica se está em algum projeto vegacheckout
    if is_path_in_projects "$work_projects_root_path" "${work_projects_folders[@]}"; then
        if [[ "$current_eas_username" != "$WORK_PROJECTS_EAS_USERNAME" ]]; then
            eas logout >/dev/null 2>&1
            login_eas "$WORK_PROJECTS_EAS_USERNAME" "$WORK_PROJECTS_EAS_PASSWORD"
            current_eas_username="$(eas whoami 2>/dev/null)"
            message="Login como $(user_logged "$WORK_PROJECTS_EAS_USERNAME")"
            auth_message "$message"
        fi

    # Verifica se está em algum projeto workspace
    elif is_path_in_projects "$personal_projects_root_path" "${personal_projects_folders[@]}"; then
        if [[ "$current_eas_username" != "$PERSONAL_PROJECTS_EAS_USERNAME" ]]; then
            eas logout >/dev/null 2>&1
            login_eas "$PERSONAL_PROJECTS_EAS_USERNAME" "$PERSONAL_PROJECTS_EAS_PASSWORD"
            current_eas_username="$(eas whoami 2>/dev/null)"
            message="Login como $(user_logged "$PERSONAL_PROJECTS_EAS_USERNAME")"
            auth_message "$message"
        fi
    fi
}

add-zsh-hook chpwd load_eas_environment
load_eas_environment
