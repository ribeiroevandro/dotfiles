function _initProject_setup_check_gh_cli
    if not command -v gh &> /dev/null
        echo "A integração com o GitHub requer o GitHub CLI ('gh')."
        read -P "O 'gh' não foi encontrado. Deseja tentar instalá-lo agora (requer Homebrew)? (s/N) " install_gh
        if test "$install_gh" = "s"
            if command -v brew &> /dev/null
                brew install gh
                if not command -v gh &> /dev/null
                    echo "A instalação falhou. Por favor, instale o 'gh' manualmente: https://cli.github.com/"
                    return 1
                end
                echo "'gh' instalado com sucesso!"
            else
                echo "Homebrew não encontrado. Por favor, instale o 'gh' manualmente: https://cli.github.com/"
                return 1
            end
        else
            echo "Por favor, instale o 'gh' manualmente para usar a integração com o GitHub."
            return 1
        end
    end
    return 0
end