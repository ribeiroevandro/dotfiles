# Módulo de instalação do initProject
# ~/.config/fish/modules/project-manager/install.fish

function initProject_install
    echo "🔧 Instalando initProject modular..."
    echo
    
    # Verificar se Fish está sendo usado
    if test "$SHELL" != (which fish)
        echo "⚠️  Você não está usando Fish como shell padrão"
        echo "Execute: chsh -s "(which fish)
        echo "Ou continue mesmo assim? (s/N)"
        read continue_install
        if not string match -qi "s*" "$continue_install"
            return 1
        end
    end
    
    # Criar estrutura de diretórios
    echo "📁 Criando estrutura de diretórios..."
    mkdir -p ~/.config/fish/functions
    mkdir -p ~/.config/fish/modules/project-manager
    
    # Definir conteúdo dos arquivos
    _create_main_function
    _create_utils_module  
    _create_config_module
    _create_setup_module
    _create_init_module
    _setup_config_file
    
    echo
    echo "🎉 Instalação concluída!"
    echo
    echo "📋 Próximos passos:"
    echo "1. Reinicie o Fish ou execute: exec fish"
    echo "2. Instale GitHub CLI: brew install gh"
    echo "3. Autentique: gh auth login"
    echo "4. Configure: initProject_setup"
    echo "5. Use: initProject"
    echo
    echo "🔧 Comandos disponíveis:"
    echo "  initProject        - Criar novo projeto"
    echo "  initProject_setup  - Configurar (ou 'psetup')"
    echo "  initProject_config - Ver configurações (ou 'pconfig')"
    echo "  initProject_reset  - Resetar (ou 'preset')"
end

function _create_main_function
    echo "📄 Criando função principal..."
    echo 'function initProject
    # Carregar módulo do project-manager
    source ~/.config/fish/modules/project-manager/utils.fish
    source ~/.config/fish/modules/project-manager/config.fish
    source ~/.config/fish/modules/project-manager/init.fish
    
    # Chamar a função principal do módulo
    _initProject_main $argv
end' > ~/.config/fish/functions/initProject.fish
    echo "✅ initProject.fish criado"
end

function _create_utils_module
    echo "📄 Criando módulo de utilitários..."
    echo '# Utilitários para o project-manager
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
    echo (string replace -ra "\\b\\w" -- (string upper (string sub -l 1 (string split "" $text))) $text)
end

# Função para expandir ~ para $HOME
function _expand_home_path
    set -l path $argv[1]
    echo (string replace "~" $HOME $path)
end

# Função para criar diretório se não existir
function _ensure_directory
    set -l dir $argv[1]
    if not test -d $dir
        mkdir -p $dir
        echo "📁 Diretório criado: $dir"
    end
end' > ~/.config/fish/modules/project-manager/utils.fish
    echo "✅ utils.fish criado"
end

function _create_config_module
    echo "📄 Criando módulo de configuração..."
    echo '# Gerenciamento de configurações
# ~/.config/fish/modules/project-manager/config.fish

# Função para ler configuração do arquivo YAML/RC
function _read_config
    set -l config_file (_get_config_file)
    
    if test -z "$config_file"
        return 1
    end
    
    # Ler configurações do arquivo (formato YAML)
    set -l devspace_dir (grep -E "^devspace_dir:" $config_file 2>/dev/null | cut -d: -f2- | string trim | string replace "~" $HOME)
    set -l opensource_dir (grep -E "^opensource_dir:" $config_file 2>/dev/null | cut -d: -f2- | string trim | string replace "~" $HOME)
    set -l devspace_org (grep -E "^devspace_org:" $config_file 2>/dev/null | cut -d: -f2- | string trim)
    
    # Fallback para formato .rc simples
    if test -z "$devspace_dir"
        set devspace_dir (grep -E "^DEVSPACE_DIR=" $config_file 2>/dev/null | cut -d= -f2- | string replace "~" $HOME)
    end
    if test -z "$opensource_dir"
        set opensource_dir (grep -E "^OPENSOURCE_DIR=" $config_file 2>/dev/null | cut -d= -f2- | string replace "~" $HOME)
    end
    if test -z "$devspace_org"
        set devspace_org (grep -E "^DEVSPACE_ORG=" $config_file 2>/dev/null | cut -d= -f2-)
    end
    
    # Definir variáveis globais
    if test -n "$devspace_dir"
        set -g PROJECT_DEVSPACE_DIR $devspace_dir
    end
    if test -n "$opensource_dir"
        set -g PROJECT_OPENSOURCE_DIR $opensource_dir
    end
    if test -n "$devspace_org"
        set -g PROJECT_DEVSPACE_ORG $devspace_org
    end
    
    return 0
end

# Função para criar arquivo de configuração
function _create_config_file
    set -l config_file $INITPROJECT_CONFIG_FILE
    
    echo "📝 Escolha o formato do arquivo de configuração:"
    echo "   1) YAML (.initproject.yml) - Recomendado"
    echo "   2) RC (.initprojectrc) - Simples"
    echo -n "Escolha [1]: "
    read format_choice
    
    switch $format_choice
        case 2
            set config_file $INITPROJECT_CONFIG_FILE_ALT
        case "*"
            set config_file $INITPROJECT_CONFIG_FILE
    end
    
    echo
    echo "📁 Configurando diretórios..."
    echo -n "Diretório DevSpace [~/www/devspace]: "
    read devspace_input
    set -l devspace_dir (test -n "$devspace_input"; and echo $devspace_input; or echo "~/www/devspace")
    
    echo -n "Diretório OpenSource [~/www/opensource]: "
    read opensource_input  
    set -l opensource_dir (test -n "$opensource_input"; and echo $opensource_input; or echo "~/www/opensource")
    
    echo -n "Organização DevSpace [devspaceapp]: "
    read org_input
    set -l devspace_org (test -n "$org_input"; and echo $org_input; or echo "devspaceapp")
    
    # Criar arquivo baseado no formato escolhido
    if string match -q "*.yml" $config_file
        echo "# Configuração do initProject
# Arquivo: $config_file
# Gerado em: "(date)"

devspace_dir: $devspace_dir
opensource_dir: $opensource_dir
devspace_org: $devspace_org

# Configurações adicionais (futuras)
# default_visibility: private
# auto_clone: true" > $config_file
    else
        echo "# Configuração do initProject  
# Arquivo: $config_file
# Gerado em: "(date)"

DEVSPACE_DIR=$devspace_dir
OPENSOURCE_DIR=$opensource_dir
DEVSPACE_ORG=$devspace_org

# Configurações adicionais (futuras)
# DEFAULT_VISIBILITY=private
# AUTO_CLONE=true" > $config_file
    end
    
    echo "✅ Arquivo de configuração criado: $config_file"
    return 0
end

# Função para mostrar configurações atuais
function initProject_config
    set -l config_file (_get_config_file)
    
    if test -z "$config_file"
        echo "❌ Nenhum arquivo de configuração encontrado"
        echo "Execute: initProject_setup"
        return 1
    end
    
    echo "=== Configurações do initProject ==="
    echo "📄 Arquivo: $config_file"
    echo
    
    # Carregar configurações
    _read_config
    
    echo "📁 DevSpace: $PROJECT_DEVSPACE_DIR"
    echo "📁 OpenSource: $PROJECT_OPENSOURCE_DIR" 
    echo "🏢 Organização: $PROJECT_DEVSPACE_ORG"
    echo
    echo "Para editar: \\$EDITOR $config_file"
    echo "Para reconfigurar: initProject_setup"
end

# Função para resetar configurações
function initProject_reset
    set -l config_file (_get_config_file)
    
    if test -n "$config_file"
        echo "🗑️  Removendo arquivo de configuração: $config_file"
        rm -f $config_file
        echo "✅ Configuração removida."
    else
        echo "ℹ️  Nenhum arquivo de configuração encontrado."
    end
    
    # Limpar variáveis da sessão
    set -e PROJECT_DEVSPACE_DIR
    set -e PROJECT_OPENSOURCE_DIR
    set -e PROJECT_DEVSPACE_ORG
    
    echo "Execute initProject_setup para reconfigurar."
end' > ~/.config/fish/modules/project-manager/config.fish
    echo "✅ config.fish criado"
end

function _create_setup_module
    echo "📄 Criando módulo de setup..."
    echo '# Setup e configuração inicial
# ~/.config/fish/modules/project-manager/setup.fish

# Função de setup principal
function initProject_setup
    # Verificar dependências primeiro
    if not _check_gh_cli
        return 1
    end
    
    echo "=== Configurando initProject ==="
    echo
    
    # Verificar se já existe configuração
    set -l existing_config (_get_config_file)
    if test -n "$existing_config"
        echo "⚠️  Já existe um arquivo de configuração: $existing_config"
        echo -n "Deseja recriar? (s/N): "
        read recreate
        
        if not string match -qi "s*" "$recreate"
            echo "Mantendo configuração atual."
            _read_config
            initProject_config
            return 0
        end
        
        echo "🗑️  Removendo configuração anterior..."
        rm -f $existing_config
    end
    
    # Criar nova configuração
    if not _create_config_file
        echo "❌ Erro ao criar arquivo de configuração"
        return 1
    end
    
    # Carregar a nova configuração
    _read_config
    
    echo
    echo "🎉 Configuração concluída com sucesso!"
    echo
    initProject_config
    echo
    echo "Agora você pode usar: initProject"
end' > ~/.config/fish/modules/project-manager/setup.fish
    echo "✅ setup.fish criado"
end

function _create_init_module
    echo "📄 Criando módulo de inicialização..."
    echo '# Função principal de inicialização de projetos
# ~/.config/fish/modules/project-manager/init.fish

# Função principal do initProject
function _initProject_main
    # Verificar se o GitHub CLI está instalado e autenticado
    if not _check_gh_cli
        return 1
    end
    
    # Verificar e carregar configurações
    if not _read_config
        echo "⚠️  Arquivo de configuração não encontrado."
        echo "Execute primeiro: initProject_setup"
        return 1
    end
    
    # Verificar se as configurações foram carregadas corretamente
    if test -z "$PROJECT_DEVSPACE_DIR"; or test -z "$PROJECT_OPENSOURCE_DIR"; or test -z "$PROJECT_DEVSPACE_ORG"
        echo "❌ Configuração inválida ou incompleta."
        echo "Execute: initProject_setup"
        return 1
    end
    
    echo -n "Onde deseja criar o projeto? (D)evSpace/(P)essoal/(S)air/(C)onfig: "
    read destiny
    
    switch $destiny
        case d D
            _create_devspace_project
        case p P
            _create_personal_project
        case s S
            _exit_project
        case c C
            initProject_config
        case "*"
            _invalid_option
    end
end

# Função para criar projeto DevSpace
function _create_devspace_project
    echo -n "Qual o projeto? "
    read project
    
    if test -z "$project"
        echo "❌ Nome do projeto não pode estar vazio"
        return 1
    end
    
    echo "📁 Criando em: $PROJECT_DEVSPACE_DIR"
    echo "🏢 Organização: $PROJECT_DEVSPACE_ORG"
    echo "📦 Repositório: $PROJECT_DEVSPACE_ORG/ds-$project"
    
    # Criar diretório se não existir
    _ensure_directory $PROJECT_DEVSPACE_DIR
    
    cd $PROJECT_DEVSPACE_DIR
    and gh repo create $PROJECT_DEVSPACE_ORG/ds-$project --private --clone
    and cd $PROJECT_DEVSPACE_DIR/ds-$project
    and echo "# "(_capitalize_text $project) >> README.md
    and echo "✅ Projeto ds-$project criado com sucesso!"
end

# Função para criar projeto pessoal/opensource
function _create_personal_project
    echo -n "Qual o projeto? "
    read proj
    
    if test -z "$proj"
        echo "❌ Nome do projeto não pode estar vazio"
        return 1
    end
    
    echo "📁 Criando em: $PROJECT_OPENSOURCE_DIR"
    echo "📦 Repositório: $proj"
    
    # Criar diretório se não existir
    _ensure_directory $PROJECT_OPENSOURCE_DIR
    
    cd $PROJECT_OPENSOURCE_DIR
    and gh repo create $proj --private --clone
    and cd $PROJECT_OPENSOURCE_DIR/$proj
    and echo "# "(_capitalize_text $proj) >> README.md
    and echo "✅ Projeto $proj criado com sucesso!"
end

# Função para sair
function _exit_project
    echo "👋 Saindo..."
    and cd ~
end

# Função para opção inválida
function _invalid_option
    echo "❌ Opção inválida"
    echo "Opções disponíveis: (D)evSpace, (P)essoal, (S)air, (C)onfig"
    and cd ~
end' > ~/.config/fish/modules/project-manager/init.fish
    echo "✅ init.fish criado"
end

function _setup_config_file
    echo "📄 Configurando config.fish..."
    
    set -l config_file ~/.config/fish/config.fish
    set -l backup_file ~/.config/fish/config.fish.backup
    
    # Fazer backup se já existir
    if test -f $config_file
        echo "🔄 Fazendo backup do config.fish existente..."
        cp $config_file $backup_file
    end
    
    # Verificar se já tem nossas configurações
    if test -f $config_file; and grep -q "initProject" $config_file
        echo "ℹ️  config.fish já contém configurações do initProject"
    else
        echo "➕ Adicionando configurações ao config.fish..."
        
        echo '
# === initProject Configuration ===
set -gx EDITOR code  # ou vim, nano, etc.

# Aliases úteis para o projeto manager
alias psetup "initProject_setup"
alias pconfig "initProject_config" 
alias preset "initProject_reset"
alias pinstall "initProject_install"

# Auto-completions customizados
complete -c initProject -a "d devspace p personal s sair c config" -d "Opções do initProject"

# Carregar módulos do project-manager automaticamente
if test -d ~/.config/fish/modules/project-manager
    source ~/.config/fish/modules/project-manager/install.fish
end' >> $config_file
        
        echo "✅ config.fish atualizado"
    end
end

# Função para desinstalar
function initProject_uninstall
    echo "🗑️  Desinstalando initProject..."
    echo -n "Tem certeza? Esta ação não pode ser desfeita (s/N): "
    read confirm
    
    if not string match -qi "s*" "$confirm"
        echo "❌ Desinstalação cancelada"
        return 1
    end
    
    # Remover arquivos
    rm -rf ~/.config/fish/modules/project-manager
    rm -f ~/.config/fish/functions/initProject.fish
    
    # Remover configurações
    set -l config_files ~/.initproject.yml ~/.initprojectrc
    for file in $config_files
        if test -f $file
            echo "🗑️  Removendo: $file"
            rm -f $file
        end
    end
    
    # Limpar variáveis
    set -e PROJECT_DEVSPACE_DIR
    set -e PROJECT_OPENSOURCE_DIR  
    set -e PROJECT_DEVSPACE_ORG
    
    echo "✅ initProject removido com sucesso"
    echo "⚠️  Você pode querer editar ~/.config/fish/config.fish manualmente"
end