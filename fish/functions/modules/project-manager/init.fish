# Função principal de inicialização de projetos
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
        case '*'
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
end