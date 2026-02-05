function success --description "Print success message"
    echo -e "\033[1;32m$argv[1] \033[0m"

end

function warning --description "Print warning message"
    echo -e "\033[1;33m$argv[1]\033[0m"
end

function error --description "Print error message"
    echo -e "\033[1;31m$argv[1]\033[0m"
end

function formating --description "Format text"
    set -l type $argv[1]
    set -l text $argv[2]
    switch $type
        case success
            success $text
        case warning
            warning $text
        case error
            error $text
        case "*"
            echo "Unknown format type: $type" >&2
    end
end
