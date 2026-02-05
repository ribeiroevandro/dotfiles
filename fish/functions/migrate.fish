function migrate --description "Move uma pasta de páginas do Nuxt 2 para o Nuxt 3"
    if test (count $argv) -eq 0
        echo "Uso: migrate nome-da-pasta"
        return 1
    end

    set pasta $argv[1]

    if not test -d "nuxt2/pages/$pasta"
        echo "Erro: Pasta 'nuxt2/pages/$pasta' não existe"
        return 1
    end

    mv "nuxt2/pages/$pasta" nuxt3/pages/

    if test $status -eq 0
        echo "✓ Pasta '$pasta' movida com sucesso para nuxt3/pages/"
    else
        echo "✗ Erro ao mover a pasta '$pasta'"
        return 1
    end
end
