# ~/.config/fish/functions/eas/login_eas.fish
# Função para realizar login no EAS

function login_eas --description "Realiza login no serviço EAS"
    # Verifica se os parâmetros foram fornecidos
    if test (count $argv) -lt 2
        echo "Uso: login_eas <username> <password>"
        return 1
    end
    
    set username $argv[1]
    set password $argv[2]
    
    # Tenta realizar o login com as credenciais fornecidas
    expo login -u "$username" -p "$password" >/dev/null 2>&1
    
    # Verifica se o login foi bem-sucedido
    if test $status -eq 0
        return 0
    else
        echo "Falha ao realizar login no EAS"
        return 1
    end
end