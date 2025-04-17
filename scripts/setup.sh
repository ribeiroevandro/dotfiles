# Adicione isso ao seu .zshrc ou arquivo de configuração do shell
function setup() {
    WORK_ROOT_FOLDER="$HOME/www/work/vegacheckout"
    PERSONAL_ROOT_FOLDER="$HOME/workspace"
    WORK_FOLDER_NAME="Trabalho"
    PERSONAL_FOLDER_NAME="Pessoal"

    SELETED_FOLDER=$(gum choose --no-show-help --header "Qual ambiente deseja acessar?" "$WORK_FOLDER_NAME" "$PERSONAL_FOLDER_NAME") || exit 1

    if [[ "$SELETED_FOLDER" == "$WORK_FOLDER_NAME" ]]; then
        cd "$WORK_ROOT_FOLDER" || return 1
        INPUT=$(gum file "$WORK_ROOT_FOLDER" --directory --no-show-help --no-permissions --no-size --height=10) || return 1
        cd "$INPUT"
    elif [[ "$SELETED_FOLDER" == "$PERSONAL_FOLDER_NAME" ]]; then
        cd "$PERSONAL_ROOT_FOLDER" || return 1
        INPUT=$(gum file --directory --no-show-help --no-permissions --no-size --height=10) || return 1
        cd "$INPUT"
    fi
}
