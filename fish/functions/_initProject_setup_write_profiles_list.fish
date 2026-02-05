function _initProject_setup_write_profiles_list --argument config_file
    set -l profiles_list
    for profile in $argv[2..-1]
        set -a profiles_list "\"$profile\""
    end
    echo "# Lista de perfis disponíveis" >> "$config_file"
        echo "set -g initProject.profiles \"$profiles_list\"" >> "$config_file"
end