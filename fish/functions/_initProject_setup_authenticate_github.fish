function _initProject_setup_authenticate_github
    gh auth status &> /dev/null
    if test $status -ne 0
        echo "Você não está autenticado no GitHub."
        read -P "Deseja executar 'gh auth login' agora para se autenticar? (s/N) " login_gh
        if test "$login_gh" = "s"
            gh auth login
            gh auth status &> /dev/null
            if test $status -ne 0
                echo "A autenticação falhou. Por favor, execute 'gh auth login' manualmente e tente novamente."
                return 1
            end
        else
            echo "A autenticação é necessária para a integração com o GitHub. Operação cancelada."
            return 1
        end
    end
    return 0
end