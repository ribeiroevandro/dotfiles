function pr_release
    # Buscar PRs abertas
    set prs (gh pr list --json number,title,author --jq '.[] | "#\(.number) - \(.title) (@\(.author.login))"')

    if test (count $prs) -eq 0
        echo "❌ Nenhuma PR aberta encontrada"
        return 1
    end

    # Selecionar a PR usando gum
    echo "🔍 Selecione a PR para fazer merge:"
    set selected_pr (printf '%s\n' $prs | gum choose)

    if test -z "$selected_pr"
        echo "❌ Nenhuma PR selecionada"
        return 1
    end

    # Extrair o número da PR
    set pr_number (echo $selected_pr | string match -r '#(\d+)' | string split '#' | tail -1 | string split ' ' | head -1)

    # Confirmar merge com opção de abortar
    if not gum confirm "Fazer merge da PR #$pr_number?"
        echo "🚫 Operação cancelada pelo usuário"
        return 0
    end

    # Escolher tipo de merge com opção de cancelar
    echo "📝 Escolha o tipo de merge:"
    set merge_type (gum choose "merge" "squash" "rebase" "❌ Cancelar")

    if test "$merge_type" = "❌ Cancelar"
        echo "🚫 Operação cancelada pelo usuário"
        return 0
    end

    # Perguntar se quer deletar o branch
    set delete_branch ""
    if gum confirm "Deletar o branch após merge?"
        set delete_branch --delete-branch
    end

    # Perguntar se quer criar tag/release com opção de cancelar
    echo "🏷️  Deseja criar tag de versão?"
    set tag_choice (gum choose "Sim, criar tag/release" "Não, apenas merge" "❌ Cancelar tudo")

    if test "$tag_choice" = "❌ Cancelar tudo"
        echo "🚫 Operação cancelada pelo usuário"
        return 0
    end

    if test "$tag_choice" = "Sim, criar tag/release"
        # Input da versão
        echo "🏷️  Digite a versão (ex: v1.0.0) ou deixe em branco para cancelar:"
        set release_version (gum input --placeholder "v1.0.0")

        if test -z "$release_version"
            echo "🚫 Versão não informada.  Operação cancelada."
            return 0
        end

        # Escolher entre tag simples ou release com opção de cancelar
        echo "📦 Criar tag simples ou release completo?"
        set tag_type (gum choose "Tag simples" "Release completo" "❌ Cancelar")

        if test "$tag_type" = "❌ Cancelar"
            echo "🚫 Operação cancelada pelo usuário"
            return 0
        end

        if test "$tag_type" = "Release completo"
            # Buscar informações da PR
            echo "📥 Buscando informações da PR..."
            set pr_info (gh pr view $pr_number --json title,body,url,author)
            set pr_title (echo $pr_info | jq -r '.title')
            set pr_body (echo $pr_info | jq -r '.body // ""')
            set pr_url (echo $pr_info | jq -r '.url')
            set pr_author (echo $pr_info | jq -r '.author.login')

            # Buscar commits da PR
            set pr_commits (gh pr view $pr_number --json commits --jq '.commits[] | "- \(.messageHeadline) (\(.oid[0:7]))"' | string collect)

            # Montar release notes automáticas
            set auto_notes "## $pr_title

**PR:** $pr_url
**Autor:** @$pr_author

### Descrição
$pr_body

### Commits incluídos
$pr_commits"

            # Escolher como criar as notas com opção de cancelar
            echo "📝 Como deseja criar as release notes?"
            set notes_option (gum choose "Notas automáticas + GitHub" "Apenas notas automáticas" "Apenas GitHub" "Editar notas automáticas" "Escrever do zero" "❌ Cancelar")

            if test "$notes_option" = "❌ Cancelar"
                echo "🚫 Operação cancelada pelo usuário"
                return 0
            end

            # Confirmação final antes de fazer merge
            echo ""
            echo "📋 Resumo da operação:"
            echo "  • PR:  #$pr_number"
            echo "  • Tipo de merge: $merge_type"
            echo "  • Deletar branch: "(test -n "$delete_branch" && echo "Sim" || echo "Não")
            echo "  • Versão: $release_version"
            echo "  • Tipo:  Release completo"
            echo "  • Notas: $notes_option"
            echo ""

            if not gum confirm "Confirma a execução desta operação?"
                echo "🚫 Operação cancelada pelo usuário"
                return 0
            end

            # Fazer o merge ANTES de criar release
            echo "🔄 Fazendo merge da PR #$pr_number..."
            gh pr merge $pr_number --$merge_type $delete_branch

            if test $status -ne 0
                echo "❌ Erro ao fazer merge da PR"
                return 1
            end

            echo "✅ Merge realizado com sucesso!"

            # Atualizar branch local
            git checkout main
            git pull origin main

            # Criar release baseado na opção escolhida
            echo "📦 Criando release $release_version..."

            switch $notes_option
                case "Notas automáticas + GitHub"
                    # Criar release com notas automáticas e adicionar as personalizadas depois
                    gh release create $release_version --title $release_version --generate-notes
                    # Buscar as notas geradas
                    set github_notes (gh release view $release_version --json body --jq '.body')
                    # Combinar com as notas automáticas
                    set combined_notes "$auto_notes

$github_notes"
                    # Atualizar a release
                    gh release edit $release_version --notes $combined_notes

                case "Apenas notas automáticas"
                    gh release create $release_version --title $release_version --notes $auto_notes

                case "Apenas GitHub"
                    gh release create $release_version --title $release_version --generate-notes

                case "Editar notas automáticas"
                    # Salvar em arquivo temporário para editar
                    set temp_file (mktemp)
                    echo $auto_notes >$temp_file
                    set edited_notes (gum write --value (cat $temp_file))
                    rm $temp_file

                    # Se o usuário não escrever nada, cancelar
                    if test -z "$edited_notes"
                        echo "🚫 Notas vazias.  Operação de release cancelada."
                        echo "⚠️  O merge da PR foi realizado, mas a release não foi criada."
                        return 0
                    end

                    gh release create $release_version --title $release_version --notes $edited_notes

                case "Escrever do zero"
                    echo "📝 Digite as notas do release:"
                    set custom_notes (gum write --placeholder "Descreva as mudanças...")

                    # Se o usuário não escrever nada, cancelar
                    if test -z "$custom_notes"
                        echo "🚫 Notas vazias.  Operação de release cancelada."
                        echo "⚠️  O merge da PR foi realizado, mas a release não foi criada."
                        return 0
                    end

                    gh release create $release_version --title $release_version --notes $custom_notes
            end

            if test $status -eq 0
                echo "✅ PR #$pr_number merged e release $release_version criada!"
            else
                echo "❌ Erro ao criar release"
                return 1
            end
        else
            # Tag simples
            # Confirmação final antes de fazer merge
            echo ""
            echo "📋 Resumo da operação:"
            echo "  • PR: #$pr_number"
            echo "  • Tipo de merge: $merge_type"
            echo "  • Deletar branch: "(test -n "$delete_branch" && echo "Sim" || echo "Não")
            echo "  • Versão: $release_version"
            echo "  • Tipo:  Tag simples"
            echo ""

            if not gum confirm "Confirma a execução desta operação?"
                echo "🚫 Operação cancelada pelo usuário"
                return 0
            end

            echo "🔄 Fazendo merge da PR #$pr_number..."
            gh pr merge $pr_number --$merge_type $delete_branch

            if test $status -eq 0
                echo "✅ Merge realizado com sucesso!"

                git checkout main
                git pull origin main

                echo "🏷️  Criando tag $release_version..."
                git tag $release_version
                git push origin $release_version

                if test $status -eq 0
                    echo "✅ PR #$pr_number merged e tag $release_version criada!"
                else
                    echo "❌ Erro ao criar tag"
                    return 1
                end
            else
                echo "❌ Erro ao fazer merge da PR"
                return 1
            end
        end
    else
        # Apenas merge sem tag
        # Confirmação final antes de fazer merge
        echo ""
        echo "📋 Resumo da operação:"
        echo "  • PR:  #$pr_number"
        echo "  • Tipo de merge: $merge_type"
        echo "  • Deletar branch: "(test -n "$delete_branch" && echo "Sim" || echo "Não")
        echo "  • Tag/Release:  Não"
        echo ""

        if not gum confirm "Confirma a execução desta operação?"
            echo "🚫 Operação cancelada pelo usuário"
            return 0
        end

        echo "🔄 Fazendo merge da PR #$pr_number..."
        gh pr merge $pr_number --$merge_type $delete_branch

        if test $status -eq 0
            echo "✅ Merge realizado com sucesso!"
        else
            echo "❌ Erro ao fazer merge da PR"
            return 1
        end
    end
end
