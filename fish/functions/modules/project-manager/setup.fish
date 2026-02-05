# Setup e configuração inicial
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
end