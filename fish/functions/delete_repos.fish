function delete_repos
    # Exemplo de uso:
    # delete_repos repo1 repo2 repo3
    # ou
    # set repos repo1 repo2 repo3
    # delete_repos $repos
    
    # Verifica se foram passados argumentos
    if test (count $argv) -eq 0
        echo "Erro: Nenhum repositório especificado"
        echo "Uso: delete_repos <repo1> <repo2> ..."
        return 1
    end
    
    # Percorre cada repositório passado como argumento
    for repo in $argv
        echo "Deletando repositório: $repo"
        
        # Executa o comando gh repo delete
        if gh repo delete devspaceapp/$repo --yes
            echo "✅ Repositório '$repo' deletado com sucesso"
        else
            echo "❌ Erro ao deletar repositório '$repo'"
        end
        
        echo "---"
    end
    
    echo "Processo concluído!"
end

# Versão alternativa que aceita um array como variável
function delete_repos_from_array
    # Exemplo de uso:
    # set my_repos repo1 repo2 repo3
    # delete_repos_from_array my_repos
    
    if test (count $argv) -ne 1
        echo "Erro: Especifique o nome da variável que contém o array"
        echo "Uso: delete_repos_from_array <nome_da_variavel>"
        return 1
    end
    
    set array_name $argv[1]
    
    # Obtém os valores da variável
    set repos $$array_name
    
    if test (count $repos) -eq 0
        echo "Erro: Array '$array_name' está vazio ou não existe"
        return 1
    end
    
    # Percorre cada repositório do array
    for repo in $repos
        echo "Deletando repositório: $repo"
        
        if gh repo delete $repo --yes
            echo "✅ Repositório '$repo' deletado com sucesso"
        else
            echo "❌ Erro ao deletar repositório '$repo'"
        end
        
        echo "---"
    end
    
    echo "Processo concluído!"
end