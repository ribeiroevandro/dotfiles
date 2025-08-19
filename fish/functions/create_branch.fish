function create_branch
    # Função para criar branches Git com padrão personalizado
    # Uso: create_branch
    
    # Verificar se estamos em um repositório Git
    if not git rev-parse --git-dir >/dev/null 2>&1
        echo "❌ Erro: Este diretório não é um repositório Git!"
        return 1
    end
    
    # 1. Perguntar o tipo de branch
    echo "🔀 Tipos de branch disponíveis:"
    echo "  1) feat    - Nova funcionalidade"
    echo "  2) fix     - Correção de bug"
    echo "  3) chore   - Tarefas de manutenção"
    echo "  4) docs    - Documentação"
    echo "  5) style   - Formatação/estilo"
    echo "  6) refactor - Refatoração"
    echo "  7) test    - Testes"
    
    read -P "📝 Digite o número ou nome do tipo de branch: " branch_type
    
    # Mapear números para tipos
    switch $branch_type
        case 1
            set branch_type "feat"
        case 2
            set branch_type "fix"
        case 3
            set branch_type "chore"
        case 4
            set branch_type "docs"
        case 5
            set branch_type "style"
        case 6
            set branch_type "refactor"
        case 7
            set branch_type "test"
        case "*"
            # Manter o valor digitado se não for número
    end
    
    # Validar tipo de branch
    if test -z "$branch_type"
        echo "❌ Tipo de branch não pode estar vazio!"
        return 1
    end
    
    # 2. Perguntar o nome da branch
    read -P "📝 Digite o nome da branch (ex: migração de tela xpto): " branch_name
    
    if test -z "$branch_name"
        echo "❌ Nome da branch não pode estar vazio!"
        return 1
    end
    
    # 3. Limpar e formatar strings
    # Converter para minúsculas e remover acentos/caracteres especiais
    set clean_type (echo $branch_type | string lower | string replace -ra '[^a-z0-9]' '')
    
    # Limpar nome da branch: minúsculas, remover acentos, caracteres especiais, e converter espaços para hífens
    set clean_name (echo $branch_name | string lower | \
                    string replace -ra '[áàâãä]' 'a' | \
                    string replace -ra '[éèêë]' 'e' | \
                    string replace -ra '[íìîï]' 'i' | \
                    string replace -ra '[óòôõö]' 'o' | \
                    string replace -ra '[úùûü]' 'u' | \
                    string replace -ra '[ç]' 'c' | \
                    string replace -ra '[ñ]' 'n' | \
                    string replace -ra '[^a-z0-9\s]' '' | \
                    string replace -ra '\s+' '-' | \
                    string replace -ra '^-+|-+$' '')
    
    # 4. Criar nome da branch no padrão especificado
    set username "ribeiroevandro"  # Você pode alterar este valor
    set full_branch_name "$username/$clean_type-$clean_name"
    
    # Mostrar preview da branch
    echo ""
    echo "🎯 Branch que será criada:"
    echo "   $full_branch_name"
    echo ""
    
    # Confirmar criação
    read -P "✅ Criar esta branch? [Y/n]: " confirm
    
    if test "$confirm" = "n" -o "$confirm" = "N"
        echo "❌ Operação cancelada."
        return 0
    end
    
    # Verificar se a branch já existe
    if git show-ref --verify --quiet "refs/heads/$full_branch_name"
        echo "❌ A branch '$full_branch_name' já existe!"
        return 1
    end
    
    # Criar e fazer checkout para a nova branch
    if git switch -c $full_branch_name
        echo ""
        echo "🎉 Branch '$full_branch_name' criada e ativada com sucesso!"
        echo "📂 Você está agora na nova branch."
        
        # Mostrar status atual
        echo ""
        git status --short
    else
        echo "❌ Erro ao criar a branch!"
        return 1
    end
end