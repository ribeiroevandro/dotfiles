# # ~/.config/fish/conf.d/eas_loader.fish
# # Este arquivo é carregado automaticamente pelo Fish durante a inicialização

# # Carrega credenciais EAS se existirem
# if test -f "$HOME/.eas_credentials"
#     source "$HOME/.eas_credentials"
# end

# # Define o caminho dos dotfiles para uso nos scripts EAS
# set -gx dotfiles_path "$HOME/workspace/dotfiles"

# if not contains "$HOME/.config/fish/functions/eas" $fish_function_path
#     set -p fish_function_path "$HOME/.config/fish/functions/eas"
# end

# # Inicializa o sistema de gerenciamento EAS para o diretório atual
# load_eas_environment