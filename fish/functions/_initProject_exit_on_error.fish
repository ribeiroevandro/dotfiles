function _initProject_exit_on_error --argument message
    if test $status -ne 0
        echo "Erro: $message" >&2
        return 1
    end
end
