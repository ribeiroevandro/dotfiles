# Configuração principal do Fish Shell
# ~/.config/fish/config.fish

# Definir variáveis de ambiente
set -gx EDITOR code  # ou vim, nano, etc.

# Aliases úteis para o projeto manager
alias psetup 'initProject_setup'
alias pconfig 'initProject_config' 
alias preset 'initProject_reset'

# Adicionar diretório de módulos ao PATH do Fish (opcional)
set -g fish_function_path $fish_function_path ~/.config/fish/modules

# Auto-completions customizados (opcional)
complete -c initProject -a 'd devspace p personal s sair c config' -d 'Opções do initProject'

# Saudação personalizada (opcional)
function fish_greeting
    echo "🐟 Fish Shell carregado!"
    echo "💼 Use 'initProject' para gerenciar projetos"
end