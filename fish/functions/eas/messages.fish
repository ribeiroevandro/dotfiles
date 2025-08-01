# ~/.config/fish/functions/eas/messages.fish
# Funções para exibir mensagens formatadas para o sistema EAS

# Exibe o nome do usuário destacado em verde
function eas_user_logged --description "Formata o nome do usuário com destaque em verde"
    set_color --bold green
    echo "$argv[1]"
    set_color normal
end

# Exibe mensagem de autenticação em roxo
function eas_auth_message --description "Exibe mensagem de autenticação em roxo"
    set_color magenta
    echo "$argv[1] realizado com sucesso."
    set_color normal
end