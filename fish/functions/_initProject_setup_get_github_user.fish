function _initProject_setup_get_github_user
    set -l github_user (gh api user --jq .login 2>/dev/null)
    if test $status -eq 0 -a -n "$github_user"
        echo $github_user
    else
        echo "Aviso: Não foi possível obter o nome de usuário do GitHub. A configuração continuará." >&2
        echo ""
    end
end