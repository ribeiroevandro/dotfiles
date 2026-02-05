# initProject Configuration
# Estrutura hierárquica seguindo boas práticas do Fish Shell

# === Funções Utilitárias ===

# Carregar configuração do arquivo padrão
function load_initProject_config
    set -l config_file "$HOME/.config/initProject/config.fish"

    if test -f $config_file
        source $config_file
        echo "Configuração carregada de: $config_file"
    else
        echo "Arquivo de configuração não encontrado: $config_file" >&2
        echo "Criando estrutura de diretórios..." >&2
        mkdir -p (dirname $config_file)
        return 1
    end
end

# Criar arquivo de configuração padrão (se não existir)
function create_default_initProject_config
    set -l config_file "$HOME/.config/initProject/config.fish"
    set -l config_dir (dirname $config_file)

    # Criar diretório se não existir
    if not test -d $config_dir
        mkdir -p $config_dir
        echo "Diretório criado: $config_dir"
    end

    # Criar arquivo apenas se não existir
    if not test -f $config_file
        echo "# initProject Configuration" > $config_file
        echo "# Estrutura hierárquica seguindo boas práticas do Fish Shell" >> $config_file
        echo "" >> $config_file
        echo "# Configurações principais" >> $config_file
        echo "set -g initProject.use_git true" >> $config_file
        echo "set -g initProject.github_user \"ribeiroevandro\"" >> $config_file
        echo "set -g initProject.base_path \"projetos\"" >> $config_file
        echo "" >> $config_file
        echo "# Lista de perfis disponíveis" >> $config_file
        echo "set -g initProject.profiles \"devspace\"" >> $config_file
        echo "" >> $config_file
        echo "# Configurações do perfil: devspace" >> $config_file
        echo "set -g initProject.profile.devspace.path \"\"" >> $config_file
        echo "set -g initProject.profile.devspace.org \"devspaceapp\"" >> $config_file
        echo "set -g initProject.profile.devspace.create_remote_repo true" >> $config_file
        echo "set -g initProject.profile.devspace.repo_name \"teste-fish-functions\"" >> $config_file

        echo "Arquivo de configuração padrão criado: $config_file"
    else
        echo "Arquivo de configuração já existe: $config_file"
    end
end


# Obter configuração geral
function get_initProject_config --argument key
    # Directly access the global variable using the provided key
    # Fish shell supports dots in variable names.
    # Example: get_initProject_config "initProject.base_path"
    # Example: get_initProject_config "initProject.profile.devspace.org"
    eval "echo \$key"
end







# === Exemplos de Uso ===

# Primeiro uso - criar configuração padrão:
# create_default_initProject_config

# Carregar configuração:
# load_initProject_config

# Usar as configurações:
# echo (get_initProject_config "github_user")              # ribeiroevandro
# echo (get_initProject_config "use_git")                  # true
# echo (get_initProject_profile_config "devspace" "org")   # devspaceapp
# list_initProject_profiles                                # devspace
# has_initProject_profile "devspace"; and echo "Existe"    # Existe

# === Função de Inicialização Completa ===

function init_initProject
    echo "Inicializando initProject..."

    # Criar arquivo padrão se necessário
    create_default_initProject_config

    # Carregar configuração
    if load_initProject_config
        echo "initProject configurado com sucesso!"
        
    else
        echo "Erro ao inicializar initProject" >&2
        return 1
    end
end
