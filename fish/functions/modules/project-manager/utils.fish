# Utilitários para o project-manager
# ~/.config/fish/modules/project-manager/utils.fish

# Configurações globais
set -g INITPROJECT_CONFIG_FILE ~/.initproject.yml
set -g INITPROJECT_CONFIG_FILE_ALT ~/.initprojectrc

# Função auxiliar para verificar dependências do GitHub CLI
function _check_gh_cli
    if not command -v gh >/dev/null 2>&1
        echo "❌ GitHub CLI não encontrado!"
        echo "📦 Instale com: brew install gh"
        echo "🔗 Ou visite: https://cli.github.com"
        return 1
    end
    
    if not gh auth status >/dev/null 2>&1
        echo "🔐 GitHub CLI não está autenticado."
        echo "Execute: gh auth login"
        return 1
    end
    
    return 0
end

# Função para detectar o arquivo de configuração
function _get_config_file
    if test -f $INITPROJECT_CONFIG_FILE
        echo $INITPROJECT_CONFIG_FILE
    else if test -f $INITPROJECT_CONFIG_FILE_ALT
        echo $INITPROJECT_CONFIG_FILE_ALT
    else
        echo ""
    end
end

# Função para capitalizar texto (primeira letra de cada palavra)
function _capitalize_text
    set -l text $argv[1]
    echo (string replace -ra '\b\w' -- (string upper (string sub -l 1 (string split '' $text))) $text)
end

# Função para expandir ~ para $HOME
function _expand_home_path
    set -l path $argv[1]
    echo (string replace '~' $HOME $path)
end

# Função para criar diretório se não existir
function _ensure_directory
    set -l dir $argv[1]
    if not test -d $dir
        mkdir -p $dir
        echo "📁 Diretório criado: $dir"
    end
end